terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  count         = 3
  ami           = "ami-06e46074ae430fba6"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-${count.index + 1}"
  }

  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  key_name = "terraform-key"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH"

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_key_pair" "key-deployer" {
  key_name = "terraform-key"
  public_key = "${file("../ssh/terraform.pub")}"
}
