variable "project_id" {
  description = "Google Project ID."
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "bucket_name" {
  description = "GCS Bucket name. Value should be unique."
  type        = string
}

variable "static_site_source" {
  description = "Source of the site to publish"
  type        = string
}