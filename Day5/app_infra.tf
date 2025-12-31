resource "aws_lb" "alb_public" {
  name               = "alb-public"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.sg_alb.id  ]
  subnets = [
    aws_subnet.subnet_public_infra_a.id,
    aws_subnet.subnet_public_infra_b.id
  ]
}

# Create listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# Creating target group
resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_main.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Registering ec2 instances in target group
resource "aws_lb_target_group_attachment" "alb-tga" {
  for_each = {
    web1 = aws_instance.ec2_web_a.id
    web2 = aws_instance.ec2_web_b.id
  }
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = each.value
  port             = 80
}