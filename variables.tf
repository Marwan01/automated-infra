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

variable "bq_instance_name" {
  description = "Name of the bigtable instance"
  type        = string
}

variable "bq_table_name" {
  description = "Name of the bigtable table"
  type        = string
}