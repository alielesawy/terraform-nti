resource "aws_vpc" "terraformVPC" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.terraformVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_tf_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.terraformVPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_tf_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraformVPC.id

  tags = {
    Name = "igw-terraform"
  }
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public_subnet.id  # Use public subnet

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_security_group" "terraformSG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.terraformVPC.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.terraformSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.terraformSG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraformSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.terraformVPC.id

  tags = {
    Name = "TerraFormRoute"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "pub" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id 
  vpc_security_group_ids = [aws_security_group.terraformSG.id]
  key_name     = aws_key_pair.my_key.key_name

  tags = {
    Name = "HelloTerraForm"
  }
}

resource "aws_instance" "pri" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_subnet.id 
  vpc_security_group_ids = [aws_security_group.terraformSG.id]

  tags = {
    Name = "ByeTerraForm"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_apache-ssh_ipv4" {
  security_group_id = aws_security_group.SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.my_key.private_key_pem
  filename = "${path.module}/my_terraform_key.pem"
}
