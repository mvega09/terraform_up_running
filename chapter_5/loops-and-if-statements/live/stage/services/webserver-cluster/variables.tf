// -----------------------------
// Main variables to parameterize the deployment
// -----------------------------

// AWS region where resources will be deployed
variable "aws_region" {
  description = "AWS region where all resources will be created."
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-stage"
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