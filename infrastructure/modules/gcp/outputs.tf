data "google_project" "current" {
  project_id = var.project_id
}

output "cloud_run_url" {
  value = "https://backend-${data.google_project.current.number}.${var.region}.run.app"
}

output "db_host" {
  value = google_sql_database_instance.postgres_instance.ip_address[0].ip_address
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}