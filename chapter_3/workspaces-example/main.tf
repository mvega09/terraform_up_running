terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    key            = "workspaces-exaple/s3/terraform.tfstate"
    region         = "us-east-2"
    bucket         = "my-bucket-mvega09"
    dynamodb_table = "terraform-locks-mvega09"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

## example ec2 for workspace
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  # instance_type  = terraform.workspace == "default" ? "t2.medium" : "t2.micro"  # Por ejemplo, aquí está cómo establecer el tipo de instancia a t2.medium en el espacio de trabajo default y t2.micro en todos los otros espacios de trabajo (ej., para ahorrar dinero cuando experimentas)

  tags = {
    Name = "ExampleInstance"
  }
}