# This file is part of a Terraform project to set up a web server on AWS EC2.
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}