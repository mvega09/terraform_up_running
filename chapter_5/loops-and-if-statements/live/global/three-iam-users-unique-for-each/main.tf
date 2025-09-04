terraform {
  required_version = ">= 1.0.0" // version lower recommended of Terraform
  required_providers {
    aws = {
      source  = "hashicorp/aws" // provider official of AWS
      version = "~> 6.0"        // version recommended of the provider AWS
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

// Create IAM users with unique names
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

// Define the read-only policy
resource "aws_iam_policy" "cloudwatch_read_only" {

  name   = "${var.policy_name_prefix}cloudwatch-read-only"

  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

// Define the full access policy
resource "aws_iam_policy" "cloudwatch_full_access" {

  name   = "${var.policy_name_prefix}cloudwatch-full-access"

  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

// Attach the full access policy to neo if the variable is true
resource "aws_iam_user_policy_attachment" "alice_cloudwatch_full_access" {
  count = var.give_alice_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

// Attach the read-only policy to Alice if she doesn't have full access
resource "aws_iam_user_policy_attachment" "alice_cloudwatch_read_only" {
  count = var.give_alice_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}