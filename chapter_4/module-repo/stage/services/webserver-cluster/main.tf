terraform {
  required_version = ">= 1.0.0" // Versión mínima recomendada de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión recomendada del proveedor AWS
    }
  }
}

// Configura la región de AWS donde se desplegarán los recursos
provider "aws" {
  region = var.aws_region // Variable definida en variables.tf
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "terramino-cluster-stage"
  db_remote_state_bucket = "my-bucket-mvega09"
  db_remote_state_key    = "state/data-stores/mysql/terraform.tfstate"

  insyance_type = "t2.micro" // In tests, a lower-cost instance than production one can be used
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_mysql_access_from_asg" {
  type                     = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id
  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}