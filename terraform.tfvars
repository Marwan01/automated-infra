project_id            = "go-automated-infra"
region                = "us-west2"
bucket_name           = "go-automated-infra-frontend-website"
static_site_source    = "public/index.html"
bq_table_name         = "go-automated-infra-table"
bq_instance_name      = "go-automated-infra-instance"
gke_cluster_name      = "go-automated-infra-gke"
deploy_image_location = "us-west2-docker.pkg.dev/go-automated-infra/go-automated-infra-repo/go-automated-infra:latest"