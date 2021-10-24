output "name" {
  description = "Bucket name"
  value       = google_storage_bucket.static_site.name
}

output "url" {
  description = "Bucket URL"
  value       = google_storage_bucket.static_site.url
}