# Creating vpc
resource "aws_vpc" "vpc_main" {
  cidr_block = "192.168.0.0/24"
  tags = {
    Name = "vpc-main"
  }
}

# Creating public and private subnets 

# Public Subnets- web tier
resource "aws_subnet" "subnet_public_web_a" {
  vpc_id                  = aws_vpc.vpc_main.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "192.168.0.0/27"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-web-a"
  }
}

resource "aws_subnet" "subnet_public_web_b" {
  vpc_id                  = aws_vpc.vpc_main.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "192.168.0.32/27"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-web-b"
  }
}

resource "aws_subnet" "subnet_private_app_a" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "ap-south-1a"
  cidr_block        = "192.168.0.64/27"
  tags = {
    Name = "subnet-private-app-a"
  }
}

resource "aws_subnet" "subnet_private_app_b" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "ap-south-1b"
  cidr_block        = "192.168.0.96/27"
  tags = {
    Name = "subnet-private-app-b"
  }
}

resource "aws_subnet" "subnet_private_db_a" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "ap-south-1a"
  cidr_block        = "192.168.0.128/27"
  tags = {
    Name = "subnet-private-db-a"
  }
}

resource "aws_subnet" "subnet_private_db_b" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "ap-south-1b"
  cidr_block        = "192.168.0.160/27"
  tags = {
    Name = "subnet-private-db-b"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "igw-main"
  }
}

# Creating Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

# Creating NAT Gateway
resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public_web_a.id
  tags = {
    Name = "nat-gw-a"
  }
}

# Creating Route table for public subnets and igw
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

# Creating Route table for private subnets and nat
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_a.id
  }
  tags = {
    Name = "rt-private"
  }
}

# Associating Public(web) subnets 
resource "aws_route_table_association" "rta_public_web_a" {
  subnet_id      = aws_subnet.subnet_public_web_a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rta_public_web_b" {
  subnet_id      = aws_subnet.subnet_public_web_b.id
  route_table_id = aws_route_table.rt_public.id
}

# Associating Private(app) subnets 
resource "aws_route_table_association" "rta_private_app_a" {
  subnet_id      = aws_subnet.subnet_private_app_a.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rta_private_app_b" {
  subnet_id      = aws_subnet.subnet_private_app_b.id
  route_table_id = aws_route_table.rt_private.id
}

# Associating Private(db) subnets 
resource "aws_route_table_association" "rta_private_db_a" {
  subnet_id      = aws_subnet.subnet_private_db_a.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rta_private_db_b" {
  subnet_id      = aws_subnet.subnet_private_db_b.id
  route_table_id = aws_route_table.rt_private.id
}
