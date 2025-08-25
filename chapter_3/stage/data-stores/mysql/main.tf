terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-mysql-instance"
  engine              = "mysql"
  db_name             = "examplemydb"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  username            = var.db_username
  password            = var.db_password

}

terraform {
  backend "s3" {
    key            = "stage/data-stores/mysql/terraform.tfstate"
    bucket         = "my-bucket-mvega09"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks-mvega09"
    encrypt        = true
  }
}