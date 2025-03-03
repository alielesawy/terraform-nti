################PUBLIC SUBNET AZ1######################

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" 
    map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

################PRIVATER SUBNET A1######################


resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a" 
  tags = {
    Name = "private-subnet-1"
  }
}


################PUBLIC SUBNET AZ2######################


resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" 
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}



#################PRIVATER SUBNET A2#####################

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b" 
  tags = {
    Name = "private-subnet-2"
  }
}