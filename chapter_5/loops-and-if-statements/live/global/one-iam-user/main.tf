terraform {
  required_version = ">= 1.12.0" // Versión mínima recomendada de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión del proveedor AWS
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "example" {
  name = var.user_name
}