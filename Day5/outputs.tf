output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.subnet_public_infra_a.id,
    aws_subnet.subnet_public_infra_b.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.subnet_private_web_a.id,
    aws_subnet.subnet_private_web_b.id
  ]
}

output "alb_dns" {
  value = aws_lb.alb_public.dns_name
}