terraform {
  required_version = ">=1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "region_1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "region_2"
}

data "aws_region" "region_1" {
  provider = aws.region_1
}

data "aws_region" "region_2" {
  provider = aws.region_2
}

data "aws_ami" "ubuntu_region_1" {
  provider    = aws.region_1
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

data "aws_ami" "ubuntu_region_2" {
  provider    = aws.region_2
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



resource "aws_instance" "region_1" {
  provider      = aws.region_1
  ami           = data.aws_ami.ubuntu_region_1.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld-from-region_1"
  }
}

resource "aws_instance" "region_2" {
  provider      = aws.region_2
  ami           = data.aws_ami.ubuntu_region_2.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld-from-region_2"
  }
}


