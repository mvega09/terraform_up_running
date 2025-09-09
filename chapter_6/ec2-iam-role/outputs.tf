output "instance_id" {
  value       = aws_instance.example.id
  description = "The ID of the EC2 instance"
}

output "instance_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the EC2 instance"
}

output "iam_role_arn" {
  value       = aws_iam_role.instance.arn
  description = "The ARN of the IAM role"
}

output "aws_iam_github_actions_oidc_arn" {
  value       = aws_iam_openid_connect_provider.github_actions.arn
  description = "The ARN of the IAM OIDC identity provider for GitHub Actions"
}

output "aws_iam_github_actions_oidc_url" {
  value       = aws_iam_openid_connect_provider.github_actions.url
  description = "The URL of the IAM OIDC identity provider for GitHub Actions"
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}