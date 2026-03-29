variable "aws_region" {
  default = "ap-south-1"
}

variable "developer_name" {
  description = "Developer name"
  type        = string
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = null
}

variable "allowed_ingress_cidr" {
  default = "0.0.0.0/0"
}
