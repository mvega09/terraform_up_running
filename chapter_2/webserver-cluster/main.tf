terraform {
  required_version = ">= 1.0.0" // Versión mínima de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión recomendada del proveedor
    }
  }
}

provider "aws" {
  region = "us-east-2" // Región donde se desplegarán los recursos
}

resource "aws_launch_template" "example" {
  name_prefix   = "terraform-" // Prefijo para el nombre de la plantilla
  image_id      = "ami-0b016c703b95ecbe4"          // ID de la imagen AMI (Amazon Linux 2023)
  instance_type = "t2.micro"                       // Tipo de instancia (micro, gratuita)

  network_interfaces {
    security_groups = [aws_security_group.instance.id]
  }

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

  lifecycle {
    create_before_destroy = true // Evita tiempo de inactividad al actualizar
  }
}

resource "aws_autoscaling_group" "example" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.default.ids // Subredes donde se desplegarán las instancias

  target_group_arns = [aws_lb_target_group.asg.arn] // Grupo de destino del ALB
  health_check_type = "ELB"                         // Tipo de verificación de salud

  min_size = 2 // Número mínimo de instancias
  max_size = 4 // Número máximo de instancias

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true // Asegura que las instancias hereden la etiqueta
  }
}

resource "aws_security_group" "instance" {
  name = var.instance_security_group_name // Nombre del grupo de seguridad

  ingress {
    from_port   = var.server_port // Puerto de inicio
    to_port     = var.server_port // Puerto de fin
    protocol    = "tcp"           // Protocolo TCP
    cidr_blocks = ["0.0.0.0/0"]   // Permite acceso desde cualquier IP (puedes restringirlo)
  }
}

data "aws_vpc" "default" {
  default = true // Utiliza la VPC por defecto
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id] // Filtra subredes por la VPC por defecto
  }
}

resource "aws_lb" "example" {
  name               = var.alb_name                 // Nombre del Application Load Balancer
  load_balancer_type = "application"                // Tipo de balanceador de carga
  subnets            = data.aws_subnets.default.ids // Subredes donde se desplegará el ALB
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn // ARN del ALB
  port              = 80                 // Puerto del listener
  protocol          = "HTTP"             // Protocolo del listener

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response" // Respuesta fija

    fixed_response {
      content_type = "text/plain"    // Tipo de contenido de la respuesta
      message_body = "404 Not Found" // Mensaje de error
      status_code  = "404"           // Código de estado HTTP
    }
  }
}

# this resource creates a target group for the auto scaling group and verifies the health of the instances
resource "aws_lb_target_group" "asg" {
  name     = var.alb_name            // Nombre del grupo de destino
  port     = var.server_port         // Puerto donde las instancias escuchan
  protocol = "HTTP"                  // Protocolo del grupo de destino
  vpc_id   = data.aws_vpc.default.id // VPC donde se encuentra el
  health_check {
    path                = "/"    // Ruta para la verificación de salud
    protocol            = "HTTP" // Protocolo de la verificación de salud
    matcher             = "200"  // Código esperado para una respuesta saludable
    interval            = 15     // Intervalo entre verificaciones
    timeout             = 3      // Tiempo de espera para una respuesta
    healthy_threshold   = 2      // Número de respuestas saludables para considerar la instancia como saludable
    unhealthy_threshold = 2      // Número de respuestas no saludables para considerar la instancia como no saludable
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn // ARN del listener del ALB
  priority     = 100                      // Prioridad de la regla

  condition {
    path_pattern {
      values = ["*"] // Patrón de ruta que coincide con todas las solicitudes
    }
  }

  action {
    type             = "forward"                   // Acción de reenvío
    target_group_arn = aws_lb_target_group.asg.arn // ARN del grupo de
  }
}

resource "aws_security_group" "alb" {
  name = var.alb_security_group_name // Nombre del grupo de seguridad del ALB

  # Allows inbound HTTP requests
  ingress {
    from_port   = 80            // Puerto de inicio (HTTP)
    to_port     = 80            // Puerto de fin (HTTP)
    protocol    = "tcp"         // Protocolo TCP
    cidr_blocks = ["0.0.0.0/0"] // Permite acceso desde cualquier IP (puedes restringirlo)
  }

  # Allows all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          // Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"] // Permite salida a cualquier dirección IP
  }
}
