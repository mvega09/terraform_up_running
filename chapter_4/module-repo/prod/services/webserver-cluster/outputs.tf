// -----------------------------
// Main outputs for the deployment
// -----------------------------

// Public URL of the Application Load Balancer (ALB)
output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "Public HTTP endpoint of the Load Balancer to access the application."
}

