// -----------------------------
// Main variables to parameterize the deployment
// -----------------------------

// AWS region where resources will be deployed
variable "aws_region" {
  description = "AWS region where all resources will be created."
  type        = string
  default     = "us-east-2"
}

// EC2 instance type to use
variable "instance_type" {
  description = "EC2 instance type for the web server group."
  type        = string
  default     = "t2.micro"
}

// Name of the Application Load Balancer (ALB)
variable "alb_name" {
  description = "Name assigned to the public Application Load Balancer (ALB)."
  type        = string
  default     = "terraform-alb-example"
}

// Security group name for EC2 instances
variable "instance_security_group_name" {
  description = "Name of the security group associated with EC2 instances."
  type        = string
  default     = "terraform-example-instance"
}

// Security group name for the ALB
variable "alb_security_group_name" {
  description = "Name of the security group associated with the Application Load Balancer."
  type        = string
  default     = "terraform-example-alb"
}

variable "db_remote_state_bucket" {
  description = "S3 bucket name where the remote state of the database is stored."
  type        = string
  default     = "my-bucket-mvega09"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-stores/mysql/terraform.tfstate"
}


