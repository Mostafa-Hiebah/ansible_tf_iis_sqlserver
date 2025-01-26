resource "aws_vpc" "hiebah_VPC" {     # VPC Name/ID using inside TF files
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Hiebah_VPC"      # VPC Name in AWS
  }
}