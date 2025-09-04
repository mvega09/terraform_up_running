terraform {
  required_version = ">= 1.0.0" // version lower recommended of Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // provider official of AWS
      version = "~> 6.0"        // version recommended of the provider AWS
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

// Create 3 EC2 instances
resource "aws_instance" "example_1" {
  count         = 3
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
}

// Create one EC2 instance in each availability zone
resource "aws_instance" "example_2" {
  count             = length(data.aws_availability_zones.all.names)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  ami               = "ami-0fb653ca2d3203ac1"
  instance_type     = "t2.micro"
}

data "aws_availability_zones" "all" {}