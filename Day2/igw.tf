resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}