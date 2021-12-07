resource "google_bigtable_instance" "instance" {
  name    = var.bq_instance_name
  project = var.project_id
  //   disable deletion_protection in order to be able to delete db via terraform destroy
  deletion_protection = false
  cluster {
    cluster_id   = "tf-instance-cluster"
    num_nodes    = 1
    storage_type = "HDD"
    zone         = "us-west2-a"
  }
}

resource "google_bigtable_table" "table" {
  name          = var.bq_table_name
  project       = var.project_id
  instance_name = google_bigtable_instance.instance.name
  column_family {
    family = "cf1"
  }
}