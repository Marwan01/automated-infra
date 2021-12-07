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

module "bigtable_table" {
  source           = "./modules/bigtable"
  project_id       = var.project_id
  bq_instance_name = var.bq_instance_name
  bq_table_name    = var.bq_table_name
}

module "gke_deployment" {
  source                = "./modules/gke"
  project_id            = var.project_id
  region                = var.region
  gke_cluster_name      = var.gke_cluster_name
  deploy_image_location = var.deploy_image_location
}