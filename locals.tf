locals {
  env = {
    default = {}
    testing = {
      project_name      = var.PROJECT_NAME
      region            = "europe-west3"
      # VPC Main
      vpc_main_name          = "${terraform.workspace}-wp-vpc-main"
      vpc_main_subnet_name   = "${terraform.workspace}-wp-subnet-main"
      vpc_main_subnet_cidr   = "10.0.0.0/24"
      # VPC DB
      vpc_db_name          = "${terraform.workspace}-wp-vpc-db"
      vpc_db_subnet_name   = "${terraform.workspace}-wp-subnet-db"
      vpc_db_subnet_cidr   = "10.0.1.0/24"
      # Firewall Main
      firewall_main_name     = "${terraform.workspace}-wp-main-firewall"
      # Firewall DB
      firewall_db_name     = "${terraform.workspace}-wp-db-firewall"
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}