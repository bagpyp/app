provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-project-453821"
    prefix = "terraform/state"
    }
}

module "cloud" {
  source = "./modules/cloud"
  project_id     = var.project_id
  region         = var.region
  image_url      = var.image_url
  env_vars       = var.env_vars
}