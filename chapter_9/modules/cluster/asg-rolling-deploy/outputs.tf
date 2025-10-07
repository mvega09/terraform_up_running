output "asg_name" {
  value       = aws_autoscaling_group.terramino.name
  description = "The name of the Auto Scaling Group"
}

output "instance_security_group_id" {
  value       = aws_security_group.terramino_instance.id
  description = "The ID of the EC2 Instance Security Group"
}