terraform {
  required_version = ">= 1.0.0" // version lower recommended of Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // provider official of AWS
      version = "~> 6.0"        // version recommended of the provider AWS
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "users" {
  source = "../../../modules/landing-zone/iam-user"

  for_each  = toset(var.user_names)
  user_name = each.value
}