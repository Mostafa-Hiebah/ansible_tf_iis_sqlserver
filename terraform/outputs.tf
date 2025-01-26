# output "frontend_ec2_public_ip" {
#   description = "Public IP address of the Frontend_ec2 instance"
#   value       = aws_instance.frontend_ec2.public_ip
# }

# # print decrypt password
# output "Administrator_Password2" {
#   value = rsadecrypt(aws_instance.frontend_ec2.password_data, tls_private_key.rsa_key_pair.private_key_pem)
#   sensitive = true
# }



# # print encrypt password
# output "Administrator_Password" {
#    value = [
#      aws_instance.frontend_ec2.password_data
#    ]
#  }

# output "Administrator_Password2" {
#   value = [
#     for i in aws_instance.frontend_ec2 : rsadecrypt(i.password_data, file("tf_key_pair.pem"))
#   ]
# }



# # Use null_resource with local-exec to write the password to a file
# resource "null_resource" "write_password_file" {
#   depends_on = [aws_instance.frontend_ec2, tls_private_key.rsa_key_pair,local_file.tf_ansible_inventory]

#   provisioner "local-exec" {
#     command = "echo '${rsadecrypt(aws_instance.frontend_ec2.password_data, tls_private_key.rsa_key_pair.private_key_pem)}' > administrator_password.txt"
#   }
# }