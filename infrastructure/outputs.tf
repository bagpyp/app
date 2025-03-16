data "google_project" "current" {
  project_id = var.project_id
}

output "cloud_run_url" {
  value = "https://${google_cloud_run_service.backend.name}-${data.google_project.current.number}.${var.region}.run.app"
}