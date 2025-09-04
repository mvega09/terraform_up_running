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

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster-instance-refresh" // Ruta al módulo webserver-cluster

  ami         = "ami-0fb653ca2d3203ac1" // AMI de Ubuntu 22.04 en us-east-2 a partir de junio de 2024

  server_text = var.server_text

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro" // Instance type para las instancias EC2, este tipo de instancia esta seleccionada ya que es elegible para el nivel gratuito, pero puede cambiarse segun las necesidades.
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Project     = "Terraform Up & Running"
    Environment = "Production"
    Owner       = "Mateo Vega"
  }
}

resource "aws_security_group" "allow_http" {
    type        = "ingress"
    security_group_id = module.webserver_cluster.security_group_id

    from_port   = 12345
    to_port     = 12345
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}