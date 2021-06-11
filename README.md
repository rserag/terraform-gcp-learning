# terraform-gcp-learning
This project contains Terraform HCL files (`.tf`) to provision entire Wordpress core infrastructure.
Terraform configuration files to provision an GKE cluster on GCP.

## Terraform versions

Version used:
*   Terraform 0.15.*

## Setup
#### Export variable with **TF_VAR_PROJECT_NAME** name
```shell
export TF_VAR_PROJECT_NAME=tf-wp-playground
```
#### Enable API service
```shell
gcloud services enable container.googleapis.com
```

## Getting Started

Before terraform apply you must download provider plugin:

```
cd terraform
terraform init
```

Select workspace you want to work with (testing)
```
terraform workspace testing
```

Display plan before apply manifest
```
terraform plan
```

Apply manifest
```
terraform apply
```

Destroy stack
```
terraform destroy
```

## Documentation
[https://registry.terraform.io/providers/hashicorp/google/latest/docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
