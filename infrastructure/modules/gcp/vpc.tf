resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.project_id}-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}

resource "google_vpc_access_connector" "serverless_connector" {
  name          = "${var.project_id}-connector"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.8.0.0/28"
  project       = var.project_id
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.project_id}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}