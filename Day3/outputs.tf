output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "ec2_id" {
  value = aws_instance.ec2.id
}

output "vpc_id_used" {
  value = data.aws_vpc.vpc_main.id
}

output "subnets_id_used" {
  value = data.aws_subnets.subnets_public.ids
}