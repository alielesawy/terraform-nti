# Public EC2 Instances (Reverse Proxy)
resource "aws_instance" "public" {
  count                  = length(var.public_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.public_sg_id]
  key_name               = var.key_name
  user_data              = <<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y nginx
                            systemctl start nginx
                            systemctl enable nginx
                            echo "proxy_pass http://${var.internal_lb_dns};" > /etc/nginx/conf.d/reverse-proxy.conf
                            systemctl restart nginx
                            EOF
  tags = {
    Name = "public-ec2-${count.index + 1}"
  }
}

# Private EC2 Instances (Web Server)
resource "aws_instance" "private" {
  count                  = length(var.private_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  user_data              = <<-EOF
                            #!/bin/bash
                            yum update -y
                            yum install -y httpd
                            systemctl start httpd
                            systemctl enable httpd
                            echo "Hello World from $(hostname -f)" > /var/www/html/index.html
                            EOF
  tags = {
    Name = "private-ec2-${count.index + 1}"
  }
}