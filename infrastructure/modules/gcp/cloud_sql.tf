resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "google_sql_database_instance" "postgres_instance" {
  name             = "${var.project_id}-sql"
  project          = var.project_id
  region           = var.region
  database_version = "POSTGRES_17"

  settings {
    tier = "db-perf-optimized-N-2"  # db-perf-optimized-N-2 for Enterprise+ GCP, db-custom-1-3840 for Enterprise GCP, db-f1-micro for free GCP (all cheapest)
    edition = "ENTERPRISE_PLUS"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.self_link
    }
  }
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_sql_database" "database" {
  name     = "db"
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_user" "user" {
  name     = "user"
  instance = google_sql_database_instance.postgres_instance.name
  password = random_password.db_password.result
}