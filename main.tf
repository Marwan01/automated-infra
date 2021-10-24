provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.gcp_auth_file
}

terraform {
  backend "gcs" {
    bucket = "marwan01-terraform-admin"
    prefix = "terraform/state"
  }
}

module "static_site_storage_bucket" {
  source      = "./modules/storage-bucket"
  project_id  = var.project_id
  bucket_name = var.bucket_name
}