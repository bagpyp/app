resource "google_service_account" "cloud_run_sa" {
  account_id   = "${var.project_id}-run-sa"
  display_name = "Cloud Run Service Account for accessing Cloud SQL and Secret Manager"
  project      = var.project_id
}

resource "google_project_iam_member" "cloud_run_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_project_iam_member" "cloud_run_secret_manager" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}