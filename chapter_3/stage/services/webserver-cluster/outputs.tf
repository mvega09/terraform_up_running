// -----------------------------
// Main outputs for the deployment
// -----------------------------

// Public URL of the Application Load Balancer (ALB)
output "lb_endpoint" {
  value       = "http://${aws_lb.terramino.dns_name}"
  description = "Public HTTP endpoint of the Load Balancer to access the application."
}

// Name of the created Auto Scaling Group
output "asg_name" {
  value       = aws_autoscaling_group.terramino.name
  description = "Name of the Auto Scaling Group managing the EC2 instances."
}