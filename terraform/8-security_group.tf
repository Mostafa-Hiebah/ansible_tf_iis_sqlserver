resource "aws_security_group" "public_security_group" {
  name = "public_security_group"
  description = "Allow SSH traffic on public"
  vpc_id = aws_vpc.hiebah_VPC.id


  ingress {
    description = "allow RDP "
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # who will connect ... any one
  }

  ingress {
    description = "allow icmp "
    from_port   = 8
    to_port     = 8
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # who will connect ... any one
  }

  ingress {
    description = "allow http "
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # who will connect ... any one
  }

  ingress {
    description = "allow WinRM-HTTPS "
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # who will connect ... any one
  }

  ingress {
    description = "allow sql "
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # who will connect ... any one
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"      # any protocol/ all type of traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "public_security_group"
  }
}







