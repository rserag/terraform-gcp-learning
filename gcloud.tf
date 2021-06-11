# set project in gclud
resource "null_resource" "set_gcloud_project" {
  provisioner "local-exec" {
    command = "gcloud config set project ${local.workspace["project_name"]}"
  }
}

# config kubectl with gcp cluster
resource "null_resource" "config_kubectl" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.gke_cluster.name} --region ${google_container_cluster.gke_cluster.location} --project ${google_container_cluster.gke_cluster.project}"
  }

  depends_on = [
    null_resource.set_gcloud_project,
    google_container_cluster.gke_cluster
  ]
}