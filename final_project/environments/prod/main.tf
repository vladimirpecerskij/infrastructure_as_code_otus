terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket                      = "tf-state-vladimir-otus-2026"
    region                      = "ru-central1"
    key                         = "final-project/prod/terraform.tfstate"
    use_path_style              = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

variable "db_password" {
  type      = string
  sensitive = true
}

module "env" {
  source          = "../../modules/three_tier_env"
  env_name        = "prod"
  subnet_cidr     = "192.168.200.0/24"
  instance_cores  = 2
  instance_memory = 4
  db_password     = var.db_password
}

output "frontend_public_ip" { value = module.env.frontend_public_ip }
output "backend_public_ip"  { value = module.env.backend_public_ip }
output "backend_private_ip" { value = module.env.backend_private_ip }
output "db_fqdn"            { value = module.env.db_fqdn }
