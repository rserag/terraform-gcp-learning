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

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_container_cluster" "gke_cluster" {
  name     = local.workspace["gke_cluster_name"]
  location = local.workspace["region"]

  depends_on = [
    google_container_cluster.gke_cluster
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

    labels = {
      "terraform_managed" = true
    }
  }

  autoscaling {
    min_node_count = local.workspace["gke_np_min_node_count"]
    max_node_count = local.workspace["gke_np_max_node_count"]
  }

  depends_on = [
    google_container_cluster.gke_cluster
  ]
}

resource "kubernetes_deployment" "wp_deployment" {
  metadata {
    name = local.workspace["k8s_deployment_name"]
    labels = {
      env = terraform.workspace
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        pod = local.workspace["k8s_pod_name"]
        env = terraform.workspace
      }
    }

    template {
      metadata {
        labels = {
          pod = local.workspace["k8s_pod_name"]
          env = terraform.workspace
        }
      }

      spec {
        container {
          image = local.workspace["k8s_container_image"]
          name = local.workspace["k8s_container_name"]

          env {
            name  = "WORDPRESS_DB_HOST"
            value = google_sql_database_instance.sql_db_instance.ip_address.0.ip_address
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = local.workspace["sql_db_user"]
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = google_sql_user.db_user.password
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = local.workspace["sql_db_name"]
          }
          env {
            name  = "WORDPRESS_TABLE_PREFIX"
            value = local.workspace["wp_table_prefix"]
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }

  depends_on = [
    null_resource.set_gcloud_project,
    google_container_cluster.gke_cluster,
    google_container_node_pool.node_pool,
    null_resource.config_kubectl
  ]
}

resource "kubernetes_service" "wp_load_balancer" {
  metadata {
    name = local.workspace["k8s_load_balancer_name"]
    labels = {
      env = terraform.workspace
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      pod = kubernetes_deployment.wp_deployment.spec.0.selector.0.match_labels.pod
    }

    port {
      port = 80
    }
  }

  depends_on = [
    kubernetes_deployment.wp_deployment
  ]
}