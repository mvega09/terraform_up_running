terraform {
  required_version = ">= 1.0.0" // Versión mínima recomendada de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión recomendada del proveedor AWS
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

// Crear un usuario IAM existente
resource "aws_iam_user" "existing_user" {
  # Make sure to update this to your own user name!
  name = "mateo"
}

