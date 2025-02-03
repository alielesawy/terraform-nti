provider "aws" {
  region = "us-east-1"
}

# 1️⃣ VPC Setup
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ReverseProxyVPC"
  }
}

# 2️⃣ Public and Private Subnets
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(["10.0.0.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(["10.0.1.0/24", "10.0.3.0/24"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)

  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

# 3️⃣ Internet Gateway & Route Table for Public Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 4️⃣ Security Groups
resource "aws_security_group" "proxy_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ProxySG"
  }
}

resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.proxy_sg.id] # Only proxy can access backend
  }

  tags = {
    Name = "BackendSG"
  }
}

# 5️⃣ Public Load Balancer for Proxy
resource "aws_lb" "public_lb" {
  name               = "Public-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.proxy_sg.id]
  subnets           = aws_subnet.public[*].id
}

# 6️⃣ Private Load Balancer for Backend
resource "aws_lb" "private_lb" {
  name               = "Private-ALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend_sg.id]
  subnets           = aws_subnet.private[*].id
}

# 7️⃣ Proxy EC2 Instances in Public Subnets
resource "aws_instance" "proxy" {
  count = 2
  ami           = "ami-12345678" # Change this to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.proxy_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "Proxy Server Running" > /var/www/html/index.html
              EOF

  tags = {
    Name = "ProxyInstance-${count.index}"
  }
}

# 8️⃣ Backend EC2 Instances in Private Subnets
resource "aws_instance" "backend" {
  count = 2
  ami           = "ami-12345678" # Change this to a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[count.index].id
  security_groups = [aws_security_group.backend_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "Backend Server Running" > /var/www/html/index.html
              EOF

  tags = {
    Name = "BackendInstance-${count.index}"
  }
}

# 9️⃣ Outputs
output "public_lb_dns" {
  value = aws_lb.public_lb.dns_name
}

output "private_lb_dns" {
  value = aws_lb.private_lb.dns_name
}
