terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
  }
}

// Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

//  Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0329ba0ced0243e2b"
  instance_type = "t2.micro"
  description = "An example EC2 instance with an IAM role"

  // Attach the IAM Instance Profile to the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.instance.name
}

// Create an IAM Role for the EC2 instance
resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// Attach a policy to the IAM Role
resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.ec2_admin_permissions.json
}

// Create an Instance Profile and attach the IAM Role to it
resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name
}

// Create an IAM Role Policy and attach it to the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Attach the policy to the role
data "aws_iam_policy_document" "ec2_admin_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}