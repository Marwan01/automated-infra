provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "static_site" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
