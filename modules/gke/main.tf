resource "google_container_cluster" "primary" {
  name               = var.gke_cluster_name
  project            = var.project_id
  location           = var.region
  initial_node_count = 1
}


data "google_client_config" "default" {}
data "google_container_cluster" "my_cluster" {
  name     = var.gke_cluster_name
  project  = var.project_id
  location = var.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "kn" {
  metadata {
    name = var.project_id
  }
}

resource "kubernetes_deployment" "kd" {
  metadata {
    name      = var.project_id
    namespace = kubernetes_namespace.kn.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.project_id
      }
    }
    template {
      metadata {
        labels = {
          app = var.project_id
        }
      }
      spec {
        container {
          image = var.deploy_image_location
          name  = var.project_id
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
    name      = var.project_id
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


