provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = ">= 1.11.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

module "gcp" {
  source = "./modules/gcp"
  project_id     = var.project_id
  region         = var.region
  image_url      = var.image_url
}