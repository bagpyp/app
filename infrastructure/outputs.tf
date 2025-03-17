output "cloud_run_url" {
  value = module.gcp.cloud_run_url
}

output "db_host" {
  value = module.gcp.db_host
}

output "db_password" {
  value     = module.gcp.db_password
  sensitive = true
}
