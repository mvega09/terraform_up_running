terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.38.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# We need to authenticate to the EKS cluster, but only after it has been created. We accomplish this by using the
# aws_eks_cluster_auth data source and having it depend on an output of the eks-cluster module.

provider "kubernetes" {
  host = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(
    module.eks_cluster.cluster_certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_name
}

# Create an EKS cluster
module "eks_cluster" {
  source = "../../modules/services/eks-cluster"

  name         = var.cluster_name
  
  min_size     = 1
  max_size     = 2
  desired_size = 1

  # Debido a la forma en que EKS funciona con ENIs, t3.small es el tipo de instancia más pequeño
  # que puede ser usado para nodos trabajadores. Si intentas algo más pequeño como t2.micro,
  # que solo tiene 4 ENIs, todos serán usados por servicios del sistema (ej. kube-proxy)
  # y no podrás desplegar tus propios Pods.
  instance_types = ["t3.small"]
}

# Deploy a simple web app into the EKS cluster

module "simple_webapp" {
  source = "../../modules/services/k8s-app"

  name = var.app_name

  image          = "nginx:latest"
  replicas       = 2
  container_port = 80

  environment_variables = {
    PROVIDER = "Terraform"
  }

  # Only deploy the app after the cluster has been deployed
  depends_on = [module.eks_cluster]
}