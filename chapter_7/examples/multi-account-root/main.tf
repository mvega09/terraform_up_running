terraform {
  required_version = ">=1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias = "parent"
}

provider "aws" {
  region = "us-east-2"
  alias = "child"
  assume_role {
    role_arn = var.child_iam_role_arn
  }
}

data "aws_caller_identity" "parent" {
  provider = aws.parent
}
data "aws_caller_identity" "child" {
  provider = aws.child
}