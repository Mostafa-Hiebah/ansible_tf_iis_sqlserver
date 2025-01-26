resource "aws_subnet" "Public_subnet" {       # for Frontend & Backend ec2
  vpc_id     = aws_vpc.hiebah_VPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Public_subnet"
  }
}



