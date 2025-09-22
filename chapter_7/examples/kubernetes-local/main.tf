terraform {
  required_version = ">=1.12.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

module "simple_webapp" {
  source = "../../modules/services/k8s-app"

  name           = "simple-webapp"
  image          = "nginx:latest"
  replicas       = 2
  container_port = 80
  environment_variables = {
    PROVIDER = "Terraform"
  }
}