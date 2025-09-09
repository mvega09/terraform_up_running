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
  
  tags = {
    Name = "${var.name}-instance-example"
  }

  // Attach the IAM Instance Profile to the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.instance.name
}

// Create an IAM Role for the EC2 instance
resource "aws_iam_role" "instance" {
  name_prefix        = "${var.name}-ec2-role"
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

# Crear un proveedor de identidad IAM OIDC que confía en GitHub
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]
}

# Obtener la huella digital OIDC de GitHub
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    
    principals {
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
      type        = "Federated"
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      # Los repos y ramas definidos en var.allowed_repos_branches
      # podrán asumir este rol IAM
      values = [
        for a in var.allowed_repos_branches :
        "repo:${a["org"]}/${a["repo"]}:ref:refs/heads/${a["branch"]}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "${var.name}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# Dar permisos a Terraform para manejar recursos (ejemplo: EC2 Full Access)
resource "aws_iam_role_policy" "github_permissions" {
  role   = aws_iam_role.github_actions_role.id
  policy = data.aws_iam_policy_document.ec2_admin_permissions.json
}