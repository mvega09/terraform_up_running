terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
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
  name          = "${var.cluster_name}-lt"
  image_id      = data.aws_ami.ubuntu.id // Utiliza la AMI de Ubuntu
  instance_type = var.instance_type      // Tipo de instancia definido en variables.tf

  // Script de inicialización
  user_data = var.user_data

  network_interfaces {
    associate_public_ip_address = true                                       // Asigna IP pública a la instancia
    security_groups             = [aws_security_group.terramino_instance.id] // Grupo de seguridad
  }

  lifecycle {
    create_before_destroy = true // Evita tiempo de inactividad al actualizar la plantilla
    precondition {
      condition     = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS Free Tier!"
    }
  }
}

// -----------------------------
// Auto Scaling Group: Grupo de instancias EC2
// -----------------------------
resource "aws_autoscaling_group" "terramino" {
  name     = "${var.cluster_name}-asg"
  min_size = var.min_size // Mínimo de instancias
  max_size = var.max_size // Máximo de instancias

  vpc_zone_identifier = var.subnet_ids // Subredes públicas

  health_check_type = var.health_check_type
  target_group_arns = var.target_group_arns


  launch_template {
    id      = aws_launch_template.terramino.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

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

  lifecycle {
    postcondition {
      condition     = length(self.availability_zones) > 1
      error_message = "you must use more than one AZ for high availability"
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
// Security Groups: Reglas de acceso
// -----------------------------

// Grupo de seguridad para las instancias EC2
resource "aws_security_group" "terramino_instance" {
  name = "${var.cluster_name}-instance-sg"

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

data "aws_ec2_instance_type" "instance" {
  instance_type = var.instance_type
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

