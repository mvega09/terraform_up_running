terraform {
  required_version = ">= 1.0.0" // Versión mínima recomendada de Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // Proveedor oficial de AWS
      version = "~> 6.0"        // Versión recomendada del proveedor AWS
    }
  }
}

// Configura la región de AWS donde se desplegarán los recursos
provider "aws" {
  region = var.aws_region // Variable definida en variables.tf
}

// Obtiene las zonas de disponibilidad disponibles en la región seleccionada
data "aws_availability_zones" "available" {
  state = "available"
}

// -----------------------------
// Módulo VPC: Red virtual privada
// -----------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

// -----------------------------
// Data Source: AMI de Ubuntu más reciente
// -----------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] // Filtra imágenes Ubuntu 22.04
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] // Canonical (propietario oficial de Ubuntu)
}

// -----------------------------
// Launch Template: Plantilla para instancias EC2
// -----------------------------
resource "aws_launch_template" "terramino" {
  name_prefix   = "${var.cluster_name}-lt"
  image_id      = data.aws_ami.ubuntu.id // Utiliza la AMI de Ubuntu
  instance_type = var.instance_type      // Tipo de instancia definido en variables.tf

  // Script de inicialización
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    db_address = data.terraform_remote_state.db.outputs.address
    db_port    = data.terraform_remote_state.db.outputs.port
  }))



  network_interfaces {
    associate_public_ip_address = true                                      // Asigna IP pública a la instancia
    security_groups             = [aws_security_group.terramino_instance.id] // Grupo de seguridad
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-instance"
    }
  }

  lifecycle {
    create_before_destroy = true // Evita tiempo de inactividad al actualizar la plantilla
  }
}

// -----------------------------
// Auto Scaling Group: Grupo de instancias EC2
// -----------------------------
resource "aws_autoscaling_group" "terramino" {
  name             = "${var.cluster_name}-${aws_launch_template.terramino.id}"
  min_size         = var.min_size // Mínimo de instancias
  max_size         = var.max_size // Máximo de instancias
  desired_capacity = 2            // Número inicial de instancias

  vpc_zone_identifier       = data.aws_subnets.default.ids // Subredes públicas
  health_check_type         = "ELB"                        // Health check por Load Balancer
  health_check_grace_period = 300                          // Tiempo de gracia para health check
  min_elb_capacity         = var.min_size                            // Requiere al menos una instancia saludable en el ELB


  launch_template {
    id      = aws_launch_template.terramino.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.terramino.arn] // Grupo de destino del Load Balancer
  
  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags :
      key => value
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# scale out at 9am every day
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.terramino.name
}

# scale in at 5pm every day
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.terramino.name
}

// -----------------------------
// Application Load Balancer (ALB)
// -----------------------------
resource "aws_lb" "terramino" {
  name               = "${var.cluster_name}-alb"
  internal           = false // Público
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terramino_lb.id]
  subnets            = data.aws_subnets.default.ids
}

// Listener: Atiende tráfico HTTP en el puerto 80
resource "aws_lb_listener" "terramino" {
  load_balancer_arn = aws_lb.terramino.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terramino.arn
  }
}

// Target Group: Grupo de instancias detrás del ALB
resource "aws_lb_target_group" "terramino" {
  name     = "${var.cluster_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/" // Ruta para health check
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

// Adjunta el Auto Scaling Group al Target Group del ALB
resource "aws_autoscaling_attachment" "terramino" {
  autoscaling_group_name = aws_autoscaling_group.terramino.id
  lb_target_group_arn    = aws_lb_target_group.terramino.arn
}


// -----------------------------
// Security Groups: Reglas de acceso
// -----------------------------

// Grupo de seguridad para las instancias EC2
resource "aws_security_group" "terramino_instance" {
  name = "${var.cluster_name}-instance-sg"

  ingress {
    from_port       = local.http_port
    to_port         = local.http_port
    protocol        = local.tcp_protocol
    cidr_blocks     = local.all_ips // Permite acceso HTTP desde cualquier IP                      
    security_groups = [aws_security_group.terramino_lb.id] // Solo permite tráfico desde el ALB
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips // Permite todo el tráfico de salida
  }

  vpc_id = data.aws_vpc.default.id
}

// Grupo de seguridad para el Load Balancer
resource "aws_security_group" "terramino_lb" {
  name_prefix = "${var.cluster_name}-lb-sg"

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

  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = var.aws_region
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terramino.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  period              = 300
  statistic           = "Average"
  threshold           = 70
  unit                = "Percent"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
  AutoScalingGroupName = aws_autoscaling_group.terramino.name
  }


  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}


locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}