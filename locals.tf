locals {
  env = {
    default = {}
    testing = {
      project_name            = var.PROJECT_NAME
      region                  = "europe-west3"
      # VPC Main
      vpc_main_name           = "${terraform.workspace}-wp-vpc-main"
      vpc_main_subnet_name    = "${terraform.workspace}-wp-subnet-main"
      vpc_main_subnet_cidr    = "10.0.0.0/24"
      # VPC DB
      vpc_db_name             = "${terraform.workspace}-wp-vpc-db"
      vpc_db_subnet_name      = "${terraform.workspace}-wp-subnet-db"
      vpc_db_subnet_cidr      = "10.0.1.0/24"
      # Firewalls
      firewall_main_name      = "${terraform.workspace}-wp-main-firewall"
      firewall_db_name        = "${terraform.workspace}-wp-db-firewall"
      # Peerings
      peering_wp2db_name      = "${terraform.workspace}-wp-peering-wp2db"
      peering_db2wp_name      = "${terraform.workspace}-wp-peering-db2wp"
      # Bastion
      bastion_name            = "${terraform.workspace}-wp-bastion"
      bastion_machine_type    = "e2-medium"
      # SQL
      sql_db_instance_name    = "${terraform.workspace}-wp-sql-db"
      sql_db_version          = "MYSQL_5_6"
      sql_db_user             = "wp_test_user"
      sql_db_name             = "${terraform.workspace}-wp"
      sql_deletion_protection = false
      # GKE
      gke_cluster_name        = "${terraform.workspace}-wp-gke-cluster"
      gke_np_name             = "${terraform.workspace}-wp-gke-node-pool"
      gke_np_machine_type     = "e2-micro"
      gke_np_node_count       = 1
      gke_np_min_node_count   = 1
      gke_np_max_node_count   = 3
      # K8s
      k8s_deployment_name     = "wordpress-deployment"
      k8s_container_image     = "wordpress"
      k8s_container_name      = "wordpress-container"
      k8s_pod_name            = "wp"
      k8s_load_balancer_name  = "wp-load-balancer"
      # Wordpress
      wp_table_prefix         = "wp_"
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}