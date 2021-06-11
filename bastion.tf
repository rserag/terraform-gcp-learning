resource "google_compute_address" "bastion_static_ip" {
  name = "ipv4-address"
}

data "google_compute_zones" "available" {}

resource "google_compute_instance" "bastion" {
  name         = local.workspace["bastion_name"]
  machine_type = local.workspace["bastion_machine_type"]
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

//  scratch_disk {
//    interface = "SCSI"
//  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_db.name

    access_config {
    //  nat_ip = google_compute_address.bastion_static_ip.address
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.bastion_static_ip.address
    }
  }

  metadata = {
    terraform_manager = true
  }

  depends_on = [
    google_compute_subnetwork.subnet_db
  ]
}