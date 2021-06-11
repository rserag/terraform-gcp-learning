output "root_password" {
  description = "SQL root password"
  value       = google_sql_database_instance.sql_db_instance.root_password
  sensitive   = true
}

output "wp_user_password" {
  description = "SQL `sql_db_user` user password"
  value       = google_sql_user.db_user.password
  sensitive   = true
}