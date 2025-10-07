terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
  }
}

resource "aws_lb" "terramino" {
  name               = var.alb_name
  internal           = false // Público
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.terramino_lb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.terramino.arn
  port              = local.http_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

// Grupo de seguridad para el Load Balancer
resource "aws_security_group" "terramino_lb" {
  name = "${var.alb_name}-sg"

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips // Permite acceso HTTP desde cualquier IP
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips // Permite todo el tráfico de salida
  }
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}