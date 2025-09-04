terraform {
  required_version = ">= 1.0.0" // Versión mínima recomendada de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión recomendada del proveedor AWS
    }
  }
}

resource "aws_iam_user" "example" {
  name = var.user_name
}