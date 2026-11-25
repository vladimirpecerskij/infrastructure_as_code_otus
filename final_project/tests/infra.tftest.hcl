variables {
  env_name        = "test"
  subnet_cidr     = "10.10.0.0/24"
  instance_cores  = 2
  instance_memory = 2
  db_password     = "TestPass123!"
}

run "verify_three_tier_architecture" {
  command = plan

  module {
    source = "./modules/three_tier_env"
  }

  assert {
    condition     = yandex_compute_instance.frontend.name == "frontend-test"
    error_message = "Frontend host name mismatch"
  }

  assert {
    condition     = yandex_compute_instance.backend.name == "backend-test"
    error_message = "Backend host name mismatch"
  }

  assert {
    condition     = yandex_mdb_postgresql_cluster.db.config[0].version == "15"
    error_message = "PostgreSQL version must be 15"
  }
}
