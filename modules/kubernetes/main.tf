resource "google_container_cluster" "primary" {
  name               = "go-bigtable-gke"
  project = "go-bigtable"
  location           = "us-central1-a"
  initial_node_count = 2
}


data "google_client_config" "default" {}
data "google_container_cluster" "my_cluster" {
  name               = "go-bigtable-gke"
  project = "go-bigtable"
  location           = "us-central1-a"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "kn" {
  metadata {
    name = "go-bigtable"
  }
}

resource "kubernetes_deployment" "kd" {
  metadata {
    name      = "go-bigtable"
    namespace = kubernetes_namespace.kn.metadata.0.name
  }
  spec {
    replicas = 1
    selector  {
      match_labels = {
        app = "go-bigtable"
      }
    }
    template {
      metadata {
        labels  = {
          app = "go-bigtable"
        }
      }
      spec {
        container {
          image = "us-west2-docker.pkg.dev/go-bigtable/go-bigtable/go-bigtable:latest"
          name  = "go-bigtable"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ks" {
  metadata {
    name      = "go-bigtable"
    namespace = kubernetes_namespace.kn.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.kd.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 8080
    }
  }
}


