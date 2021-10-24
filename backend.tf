terraform {
  backend "gcs" {
    bucket = var.project_id
    prefix = "terraform/state"
    credentials = var.gcp_auth_file
  }
}
