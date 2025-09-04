terraform {
  required_version = ">= 1.0.0" // version lower recommended of Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // provider official of AWS
      version = "~> 6.0"        // version recommended of the provider AWS
    }
  }
}

// configure the AWS region where resources will be deployed
provider "aws" {
  region = var.aws_region // Variable definida en variables.tf
  default_tags {
    tags = {
      Owner     = "team-foo"
      ManagedBy = "Terraform"
    }
  }
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name           = "terramino-cluster-prod"
  db_remote_state_bucket = "my-bucket-mvega09"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type      = "t2.micro" // A different instance is used in production, in this example i use the free tier one
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true

  custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "Terraform"
  }

}
