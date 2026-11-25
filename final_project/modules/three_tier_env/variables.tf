variable "env_name" { type = string }
variable "subnet_cidr" { type = string }
variable "instance_cores" { type = number }
variable "instance_memory" { type = number }
variable "db_password" {
  type      = string
  sensitive = true
}
