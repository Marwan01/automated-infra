variable "project_id" {
  description = "Google Project ID."
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