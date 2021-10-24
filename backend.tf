terraform {
 backend "gcs" {
   bucket  = "marwan01-terraform-admin"
   prefix  = "terraform/state"
 }
}
