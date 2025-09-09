terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_kms_secrets" "creds" {
  secret {
    name    = "db"
    payload = file("${path.module}/db-creds.yml.encrypted")
  }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine             = "mysql"
  allocated_storage  = 10
  instance_class     = "db.t3.micro"
  skip_final_snapshot = true
  db_name            = var.db_name
  
  # ¿Cómo configurar estos parámetros de forma segura?
  username = local.db_creds.username
  password = local.db_creds.password
}