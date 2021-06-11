// Configure the Google Cloud provider
provider "google" {
  project  = local.workspace["project_name"]
  region   = "europe-west3"
}

//k8s Provider
provider "kubernetes" {
  host                   = data.google_container_cluster.gke_cluster.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate)
}