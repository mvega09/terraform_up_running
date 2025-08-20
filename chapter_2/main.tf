terraform {
  required_version = ">= 1.0.0" // Versión mínima de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión recomendada del proveedor
    }
  }
}

// Configuración del proveedor AWS
provider "aws" {
  region = "us-east-2" // Región donde se desplegarán los recursos
}

// Recurso: Instancia EC2
resource "aws_instance" "example" {
  ami                    = "ami-0b016c703b95ecbe4"          // ID de la imagen AMI (Amazon Linux 2023)
  instance_type          = "t2.micro"                       // Tipo de instancia (micro, gratuita)
  vpc_security_group_ids = [aws_security_group.instance.id] // Grupo de seguridad asociado

  // Script de inicialización (user_data) que instala y configura Apache
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

  user_data_replace_on_change = true // Reinicia la instancia si cambia el script

  tags = {
    Name = "terraform-example" // Etiqueta para identificar la instancia
  }
}

// Recurso: Grupo de seguridad para la instancia EC2
resource "aws_security_group" "instance" {
  name = "terraform-example-instance" // Nombre del grupo de seguridad

  // Regla de ingreso: permite tráfico TCP en el puerto definido por la variable server_port
  ingress {
    from_port   = var.server_port // Puerto de inicio
    to_port     = var.server_port // Puerto de fin
    protocol    = "tcp"           // Protocolo TCP
    cidr_blocks = ["0.0.0.0/0"]   // Permite acceso desde cualquier IP (puedes restringirlo)
  }

  // Regla de egreso: permite todo el tráfico de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          // Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"] // Permite salida a cualquier dirección IP
  }
}
