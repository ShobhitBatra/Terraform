# vpc
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-main"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "igw-main"
  }
}

# creating a nat
resource "aws_eip" "eip_nat" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw_public_infra_a" {
  subnet_id = aws_subnet.subnet_public_infra_a.id
  allocation_id = aws_eip.eip_nat.id
  tags = {
    Name = "nat-gw-public-infra-a"
  }
}

# Subnets (2 private and 2 public)

# AZ A
resource "aws_subnet" "subnet_public_infra_a" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "192.168.0.0/26"
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-infra-a"
  }
}

resource "aws_subnet" "subnet_private_web_a" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "192.168.0.64/26"
  availability_zone = var.az_a

  tags = {
    Name = "subnet-private-web-a"
  }
}

# AZ B
resource "aws_subnet" "subnet_public_infra_b" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "192.168.0.128/26"
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-infra-b"
  }
}

resource "aws_subnet" "subnet_private_web_b" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "192.168.0.192/26"
  availability_zone = var.az_b

  tags = {
    Name = "subnet-private-web-b"
  }
}

# Route Tables

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main.id
  }

  tags = {
    Name = "rt-public"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_public_infra_a.id
  }

  tags = {
    Name = "rt-private"
  }
}

# Route Table Associations

# Public
resource "aws_route_table_association" "rta_public_infra_a" {
  subnet_id      = aws_subnet.subnet_public_infra_a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rta_public_infra_b" {
  subnet_id      = aws_subnet.subnet_public_infra_b.id
  route_table_id = aws_route_table.rt_public.id
}

# Private
resource "aws_route_table_association" "rta_private_web_a" {
  subnet_id      = aws_subnet.subnet_private_web_a.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rta_private_web_b" {
  subnet_id      = aws_subnet.subnet_private_web_b.id
  route_table_id = aws_route_table.rt_private.id
}



