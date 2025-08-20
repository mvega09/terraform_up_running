terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-0b016c703b95ecbe4" # Example AMI ID, replace with a valid one
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]


  user_data = <<-EOT
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              sudo sed -i "s/Listen 80/Listen ${var.server_port}/" /etc/httpd/conf/httpd.conf
              echo "<h1>¡Hola desde Terraform!</h1>" | sudo tee /var/www/html/index.html
              sudo systemctl restart httpd
              EOT

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
