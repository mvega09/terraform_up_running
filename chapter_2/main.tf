provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0b016c703b95ecbe4" # Example AMI ID, replace with a valid one
  instance_type = "t2.micro"
  
    tags = {
        Name = "terraform-example"
    }
}