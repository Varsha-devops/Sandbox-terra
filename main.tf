provider "aws" {
  region = var.aws_region
}

##############################
# Fetch Existing VPC by CIDR
##############################
data "aws_vpc" "selected_vpc" {
  filter {
    name   = "cidr-block"
    values = ["172.31.0.0/16"]
  }
}

##############################
# Fetch Existing Subnet by CIDR
##############################
data "aws_subnet" "selected_subnet" {
  filter {
    name   = "cidr-block"
    values = ["172.31.32.0/20"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }
}

##############################
# Security Group
##############################
resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg-${var.developer_name}"
  description = "Sandbox SG for ${var.developer_name}"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ingress_cidr]
  }

  ingress {
    description = "App Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ingress_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sandbox-sg-${var.developer_name}"
    Owner = var.developer_name
  }
}

##############################
# EC2 Instance
##############################
resource "aws_instance" "sandbox_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = data.aws_subnet.selected_subnet.id
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]

  key_name = var.key_name

  tags = {
    Name        = "sandbox-${var.developer_name}"
    Owner       = var.developer_name
    Environment = "sandbox"
    Purpose     = "temporary"
  }
}
