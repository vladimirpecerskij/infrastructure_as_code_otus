terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "net" {
  name = "net-${var.env_name}"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet-${var.env_name}"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.subnet_cidr]
}

resource "yandex_vpc_security_group" "sg" {
  name       = "sg-${var.env_name}"
  network_id = yandex_vpc_network.net.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP Frontend"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Internal traffic (Backend 8080 & Postgres 5432)"
    v4_cidr_blocks = [var.subnet_cidr]
    from_port      = 1
    to_port        = 65535
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# Хост 1: Frontend (Nginx Reverse Proxy)
resource "yandex_compute_instance" "frontend" {
  name        = "frontend-${var.env_name}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yc.pub")}"
  }
}

# Хост 2: Backend (Python App Server)
resource "yandex_compute_instance" "backend" {
  name        = "backend-${var.env_name}"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = var.instance_cores
    memory = var.instance_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yc.pub")}"
  }
}

# Хост 3: Database (Managed PostgreSQL)
resource "yandex_mdb_postgresql_cluster" "db" {
  name               = "pg-${var.env_name}"
  environment        = "PRESTABLE"
  network_id         = yandex_vpc_network.net.id
  security_group_ids = [yandex_vpc_security_group.sg.id]

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet.id
  }
}

resource "yandex_mdb_postgresql_database" "app_db" {
  cluster_id = yandex_mdb_postgresql_cluster.db.id
  name       = "appdb"
  owner      = "appuser"
  depends_on = [yandex_mdb_postgresql_user.app_user]
}

resource "yandex_mdb_postgresql_user" "app_user" {
  cluster_id = yandex_mdb_postgresql_cluster.db.id
  name       = "appuser"
  password   = var.db_password
}
