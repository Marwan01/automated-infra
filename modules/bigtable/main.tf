resource "google_bigtable_instance" "instance" {
  name    = "my-instance-id"
  project = "go-bigtable"
  //   add deletion_protection in order to be able to delete db via terraform destroy
  deletion_protection = false
  cluster {
    cluster_id   = "tf-instance-cluster"
    num_nodes    = 1
    storage_type = "HDD"
    zone         = "us-west2-a"
  }
}

resource "google_bigtable_table" "table" {
  name          = "my-table"
  project       = "go-bigtable"
  instance_name = google_bigtable_instance.instance.name
  column_family {
    family = "cf1"
  }
}