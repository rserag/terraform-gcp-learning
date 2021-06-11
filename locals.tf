locals {
  env = {
    default = {}
    testing = {
      project_name      = "learning-rafayel-sahakyan"
      # VPC
      vpc_name          = "${terraform.workspace}-wp-vpc"
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}