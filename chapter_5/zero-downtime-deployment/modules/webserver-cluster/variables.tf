# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

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

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "terramino-cluster"
}

variable "min_size" {
  description = "The number of EC2 Instances minimum in the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The number of EC2 Instances maximum in the ASG"
  type        = number
  default     = 3
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "custom_tags" {
  description = "Tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "server_text" {
  description = "The text the web server should return"
  default     = "Hello, World"
  type        = string
}