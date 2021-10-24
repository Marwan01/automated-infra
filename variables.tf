variable "project_id" {
  description = "Google Project ID."
  type        = string
}

variable "bucket_name" {
  description = "GCS Bucket name. Value should be unique."
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-west2"
}

variable "gcp_auth_file" {
  type        = string
  sensitive   = true
  description = "Google Cloud service account credentials"
}