# Creating EC2 instances

# az-a
resource "aws_instance" "ec2_web_a" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  subnet_id                   = aws_subnet.subnet_private_web_a.id
  associate_public_ip_address = false
  user_data                   = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx

    echo "<h1>Web Server 1 from az-a</h1>" > /var/www/html/index.html

    systemctl restart nginx
    systemctl enable nginx
  EOF

  tags = {
    Name = "ec2-web-a"
  }
}

# az-b
resource "aws_instance" "ec2_web_b" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  subnet_id                   = aws_subnet.subnet_private_web_b.id
  associate_public_ip_address = false
  user_data                   = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx

    echo "<h1>Web Server 2 from az-b</h1>" > /var/www/html/index.html

    systemctl restart nginx
    systemctl enable nginx
  EOF
  
  tags = {
    Name = "ec2-web-b"
  }
}
