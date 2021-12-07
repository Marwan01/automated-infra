provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "tf-state-go-automated-infra"
    prefix = "terraform/state"
  }
}

module "static_site_storage_bucket" {
  source             = "./modules/storage-bucket"
  project_id         = var.project_id
  region             = var.region
  bucket_name        = var.bucket_name
  static_site_source = var.static_site_source
}