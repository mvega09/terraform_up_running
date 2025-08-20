provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0b016c703b95ecbe4" # Example AMI ID, replace with a valid one
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]


  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.xhtml
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  
  user_data_replace_on_change = true

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "instance" {
  name        = "terraform-example-instance"

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
