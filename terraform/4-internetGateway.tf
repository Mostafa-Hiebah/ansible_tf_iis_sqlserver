resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.hiebah_VPC.id

  tags = {
    Name = "gateway"
  }
}