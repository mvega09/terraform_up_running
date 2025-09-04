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
  region = "us-east-2" // Región AWS donde se desplegarán los recursos
}

# This was the old identifier for the security group. Below is the same security group, but with the new identifier.
# resource "aws_security_group" "instance" {
#   name = var.security_group_name
# }

resource "aws_security_group" "cluster_instance" {
  name = var.security_group_name
}

# Automatically update state to handle the security group's identifier being changed
moved {
  from = aws_security_group.instance
  to   = aws_security_group.cluster_instance
}