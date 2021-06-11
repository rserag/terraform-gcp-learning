resource "google_container_cluster" "gke_cluster" {
  name                     = local.workspace["gke_cluster_name"]
  description              = "GKE cluster for wordpress project"
  project                  = local.workspace["project_name"]
  location                 = local.workspace["region"]
  network                  = google_compute_network.vpc_network_main.name
  subnetwork               = google_compute_subnetwork.subnet_main.name
  remove_default_node_pool = true
  initial_node_count       = 1

  depends_on = [
    google_compute_subnetwork.subnet_main
  ]
}

resource "google_container_node_pool" "node_pool" {
  name        = local.workspace["gke_np_name"]
  project     = local.workspace["project_name"]
  location    = local.workspace["region"]
  cluster     = google_container_cluster.gke_cluster.name
  node_count  = local.workspace["gke_np_node_count"]

  node_config {
    preemptible = true
    machine_type = local.workspace["gke_np_machine_type"]
  }

  autoscaling {
    min_node_count = local.workspace["gke_np_min_node_count"]
    max_node_count = local.workspace["gke_np_max_node_count"]
  }

  depends_on = [
    google_container_cluster.gke_cluster
  ]
}