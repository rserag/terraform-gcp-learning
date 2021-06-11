output "db_host" {
  value = google_sql_database_instance.sql_db_instance.ip_address.0.ip_address

  depends_on = [
    google_sql_database_instance.sql_db_instance
  ]
}

output "db_name" {
  value = local.workspace["sql_db_name"]
}

output "db_username" {
  value = local.workspace["sql_db_user"]
}

output "db_root_password" {
  description = "SQL root password"
  value       = google_sql_database_instance.sql_db_instance.root_password
  sensitive   = true

  depends_on = [
    google_sql_database_instance.sql_db_instance
  ]
}

output "db_user_password" {
  description = "SQL `sql_db_user` user password"
  value       = google_sql_user.db_user.password
  sensitive   = true

  depends_on = [
    google_sql_user.db_user
  ]
}

output "wp_url" {
  value = kubernetes_service.wp_load_balancer.status.0.load_balancer.0.ingress

  depends_on = [
    kubernetes_service.wp_load_balancer
  ]
}