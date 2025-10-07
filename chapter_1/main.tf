terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxxxxxx" // Cambia la ami para desplegar la instancia en AWS
  instance_type = "t2.micro"
}