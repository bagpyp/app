resource "google_cloud_run_service" "backend" {
  name     = "backend"
  location = var.region

  template {
    spec {
      containers {
        image = var.image_url
        ports {
          container_port = 8080
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
