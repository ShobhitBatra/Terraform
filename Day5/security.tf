# Creating sg for alb
resource "aws_security_group" "sg_alb" {
  name        = "alb-sg"
  description = "security group for our alb"
  vpc_id      = aws_vpc.vpc_main.id
  tags = {
    Name = "sg-alb"
  }
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "allow_all_outbound_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_alb.id
}

# Creating sg for web tier instances
resource "aws_security_group" "sg_web" {
  name        = "web-sg"
  description = "security group for our instances in web tier"
  vpc_id      = aws_vpc.vpc_main.id
  tags = {
    Name = "sg-web"
  }
}

resource "aws_security_group_rule" "allow_alb_to_web" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_web.id
  source_security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "allow_all_outbound_web" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_web.id
}