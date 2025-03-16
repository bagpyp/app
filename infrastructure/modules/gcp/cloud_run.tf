resource "google_cloud_run_service" "backend" {
  name     = "backend"
  location = var.region

  template {
    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.serverless_connector.name
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
      }
    }
    spec {
      service_account_name = google_service_account.cloud_run_sa.email
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/backend-repo/backend:latest"
        ports {
          container_port = 8080
        }

        env {
          name  = "DB_HOST"
          value = google_sql_database_instance.postgres_instance.ip_address[0].ip_address
        }
        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.db_password.secret_id
              key  = google_secret_manager_secret_version.db_password_version.version
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_policy" "invoker" {
  location    = var.region
  project     = var.project_id
  service     = google_cloud_run_service.backend.name
  policy_data = data.google_iam_policy.invoker.policy_data
}

data "google_iam_policy" "invoker" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}
