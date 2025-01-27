# generate public & private key
resource "tls_private_key" "rsa_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


# extract public key
resource "aws_key_pair" "tf_public_key_pair" {
  key_name   = "tf_key_pair2"
  public_key = tls_private_key.rsa_key_pair.public_key_openssh
}


# store private key into my machine to use it with ssh
resource "local_file" "tf_local_file" {
  content  = tls_private_key.rsa_key_pair.private_key_pem
  filename = "tf_key_pair2.pem"
}
