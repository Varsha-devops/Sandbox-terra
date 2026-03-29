terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "sandbox-terra-backend"
    key            = "self-service-ec2/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = true
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}