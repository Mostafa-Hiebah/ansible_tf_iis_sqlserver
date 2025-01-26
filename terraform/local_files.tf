resource "local_file" "tf_ansible_inventory" {
  content  = <<-DOC
    [windows]
    node2 ansible_host=${aws_instance.frontend_ec2.public_ip} ansible_user=Administrator ansible_password='${rsadecrypt(aws_instance.frontend_ec2.password_data, tls_private_key.rsa_key_pair.private_key_pem)}' 
    
    [windows:vars]
    ansible_connection=winrm
    ; ansible_user=mostafa
    ; ansible_password=''
    ansible_winrm_transport=ntlm
    ansible_winrm_server_cert_validation=ignore
    become=False
    become_method=runas
    become_user=administrator
    become_ask_pass=False

  DOC
  filename = "../inventory"
}




# resource "local_file" "tf_ansible_inventory" {
#   content = <<-DOC
#     ${join("\n", [for group, instances in local.grouped_instances : 
#       "[${group}]\n${join("\n", [for instance in instances : 
#         "${instance.private_ip} ansible_host=${instance.public_ip} ansible_user=Administrator ansible_password='${rsadecrypt(instance.password_data, tls_private_key.rsa_key_pair.private_key_pem)}'"
#       ])}"
#     ])}

#   DOC

#   filename = "../inventory"
# }

# locals {
#   # Grouping instances by their 'group' attribute
#   grouped_instances = {
#     for instance in aws_instance.my_ec2 : 
#     instance.tags["Name"] => [instance]
#   }
# }


