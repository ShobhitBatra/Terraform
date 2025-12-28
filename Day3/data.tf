data "aws_vpc" "vpc_main" {
  tags = {
    Name = "vpc-main"
  }
  cidr_block = "192.168.0.0/24"
}

data "aws_subnets" "subnets_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_main.id]
  }
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
} 