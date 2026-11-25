output "frontend_public_ip" {
  value = yandex_compute_instance.frontend.network_interface[0].nat_ip_address
}

output "backend_public_ip" {
  value = yandex_compute_instance.backend.network_interface[0].nat_ip_address
}

output "backend_private_ip" {
  value = yandex_compute_instance.backend.network_interface[0].ip_address
}

output "db_fqdn" {
  value = yandex_mdb_postgresql_cluster.db.host[0].fqdn
}
