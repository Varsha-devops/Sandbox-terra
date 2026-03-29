locals {
  common_tags = {
    Name        = "sandbox-${var.developer_name}"
    Owner       = var.developer_name
    Environment = "sandbox"
    Purpose     = "temporary-self-service"
    CreatedBy   = "jenkins"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "sandbox_sg" {
  name        = "sandbox-sg-${var.developer_name}"
  description = "Security group for sandbox EC2 of ${var.developer_name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ingress_cidr]
  }

  ingress {
    description = "App Port Example"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ingress_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "sandbox_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]
  key_name               = var.key_name

  tags = local.common_tags
}