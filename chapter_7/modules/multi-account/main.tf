terraform {
  required_version = ">=1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
      configuration_aliases = [aws.parent, aws.child]
    }
  }
}

data "aws_caller_identity" "parent" {
  provider = aws.parent
}

data "aws_caller_identity" "child" {
  provider = aws.child
}