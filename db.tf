resource "random_password" "root_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "user_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "google_sql_database_instance" "sql_db_instance" {
  name                = local.workspace["sql_db_instance_name"]
  database_version    = local.workspace["sql_db_version"]
  region              = local.workspace["region"]
  root_password       = random_password.root_password.result
  deletion_protection = local.workspace["sql_deletion_protection"]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true

      authorized_networks {
        name = "sqlnet"
        value = "0.0.0.0/0"
      }
    }
  }

  depends_on = [
    google_compute_subnetwork.subnet_db
  ]
}

resource "google_sql_database" "sql_db" {
  name     = local.workspace["sql_db_name"]
  instance = google_sql_database_instance.sql_db_instance.name

  depends_on = [
    google_sql_database_instance.sql_db_instance
  ]
}

resource "google_sql_user" "db_user" {
  name = local.workspace["sql_db_user"]
  instance = google_sql_database_instance.sql_db_instance.name
  password = random_password.user_password.result

  depends_on = [
    google_sql_database_instance.sql_db_instance
  ]
}