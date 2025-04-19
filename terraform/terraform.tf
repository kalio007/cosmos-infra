terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
  backend "remote" {
    organization = "cosmos-hub"

    workspaces {
      name = "comos-hub"
    }
  }
  required_version = ">= 1.6.3"
}


# for terrafrom cloud
# terraform init -backend-config="token=YOUR_TF_CLOUD_TOKEN"
