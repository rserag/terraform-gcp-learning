//vpc
resource "google_compute_network" "vpc_network" {
  name        = local.workspace["vpc_name"]
  description = "vpc network for testing"
  project     = local.workspace["project_name"]
}

//resource "google_sql_database" "database" {
//  name     = "my-database"
//  instance = google_sql_database_instance.instance.name
//}

//resource "google_sql_database_instance" "instance" {
//  name   = "my-database-instance"
//  region = "us-central1"
//  settings {
//    tier = "db-f1-micro"
//  }
//
//  deletion_protection  = "false"
//}

//resource "google_compute_instance_template" "tpl" {
//  name         = "template"
//  machine_type = "e2-micro"
//
//  disk {
//    source_image = "debian-cloud/debian-10"
//    auto_delete  = true
//    disk_size_gb = 20
//    boot         = true
//  }
//
//  network_interface {
//    network = "default"
//  }
//
//  metadata = {
//    foo = "bar"
//  }
//
//  can_ip_forward = true
//}
//
//resource "google_compute_instance_from_template" "tpl" {
//  name = "instance-from-template"
//  zone = "us-central1-a"
//
//  source_instance_template = google_compute_instance_template.tpl.id
//
//  // Override fields from instance template
//  can_ip_forward = false
//  labels = {
//    my_key = "my_value"
//  }
//}