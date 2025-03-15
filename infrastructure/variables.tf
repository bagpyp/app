variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "project-453821"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "image_url" {
  description = "Container image URL"
  type        = string
}

variable "env_vars" {
  description = "Environment variables for Cloud Run"
  type        = map(string)
  default     = { ENV = "production" }
}
