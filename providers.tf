// Configure the Google Cloud provider
provider "google" {
  project  = local.workspace["project_name"]
  region   = "europe-west3"
}

//k8s Provider
provider "kubernetes" {}