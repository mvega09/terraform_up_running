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
  source = "../../../../modules/services/webserver-cluster"

  ami         = "ami-0fb653ca2d3203ac1"

  server_text = var.server_text

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro" // Instance type para las instancias EC2, este tipo de instancia esta seleccionada ya que es elegible para el nivel gratuito, pero puede cambiarse segun las necesidadesen producción, en este ejemplo uso la del nivel gratuito
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true
}