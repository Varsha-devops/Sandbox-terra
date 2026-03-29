output "instance_id" {
  value = aws_instance.sandbox_ec2.id
}

output "public_ip" {
  value = aws_instance.sandbox_ec2.public_ip
}

output "subnet_used" {
  value = data.aws_subnet.selected_subnet.id
}

output "vpc_used" {
  value = data.aws_vpc.selected_vpc.id
}
