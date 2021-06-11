resource "google_compute_network" "vpc_network_main" {
  name        = local.workspace["vpc_main_name"]
  description = "vpc main network for testing"
  project     = local.workspace["project_name"]
}

resource "google_compute_subnetwork" "subnet_main" {
  name          = local.workspace["vpc_main_subnet_name"]
  ip_cidr_range = local.workspace["vpc_main_subnet_cidr"]
  project       = local.workspace["project_name"]
  region        = local.workspace["region"]
  network       = google_compute_network.vpc_network_main.id
}

resource "google_compute_firewall" "firewall_main" {
  name    = local.workspace["firewall_main_name"]
  network = google_compute_network.vpc_network_main.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["80", "8080"]
  }

  source_tags = ["wp", "wordpress"]
}

resource "google_compute_network" "vpc_network_db" {
  name        = local.workspace["vpc_db_name"]
  description = "vpc db network for testing"
  project     = local.workspace["project_name"]
}

resource "google_compute_subnetwork" "subnet_db" {
  name          = local.workspace["vpc_db_subnet_name"]
  ip_cidr_range = local.workspace["vpc_db_subnet_cidr"]
  project       = local.workspace["project_name"]
  region        = local.workspace["region"]
  network       = google_compute_network.vpc_network_db.id
}

resource "google_compute_firewall" "firewall_db" {
  name    = local.workspace["firewall_db_name"]
  network = google_compute_network.vpc_network_db.name

  allow {
    protocol = "tcp"
    ports = ["80", "8080", "3306"]
  }

  source_tags = ["db", "database"]
}