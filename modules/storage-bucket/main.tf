resource "google_storage_bucket" "static_site" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  website {
    main_page_suffix = "public/index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "editor" {
  bucket      = google_storage_bucket.static_site.name
  policy_data = data.google_iam_policy.viewer.policy_data
}

resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "public/index.html"
  bucket = google_storage_bucket.static_site.name
}