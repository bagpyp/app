variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "image_url" {
  description = "Container image URL for Cloud Run"
  type        = string
}


variable "env_vars" {
  description = "Environment variables for Cloud Run"
  type        = map(string)
  default     = {}
}


