resource "aws_instance" "frontend_ec2" {
  ami           = "ami-04f77c9cd94746b09"
  instance_type = "t3.xlarge"#"t3.micro"    # 2 VCPU & 1GB RAM
  # count         = 1
  subnet_id     = aws_subnet.Public_subnet.id
  vpc_security_group_ids =[aws_security_group.public_security_group.id ]
  key_name = aws_key_pair.tf_public_key_pair.id    # put public key inside ec2
  associate_public_ip_address = true
  get_password_data = true
  tags = {
    Name = "frontend_ec2"
  }
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 60
    delete_on_termination = true
  }
  user_data = <<-EOF
    <powershell>
$scriptContent = @'

$publicIP = Invoke-RestMethod -Uri "https://api.ipify.org"
$filePath = "C:\\public_ip.txt"
Set-Content -Path $filePath -Value "$publicIp"

# Define Variables
$dnsName = "$publicIP"
# Generate Self-Signed Certificate
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $dnsName -KeyLength 2048 -NotAfter (Get-Date).AddYears(5) -FriendlyName "WinRM HTTPS Certificate"
$certThumbprint = $cert.Thumbprint
Write-Output "Certificate Thumbprint: $certThumbprint"

# Create HTTPS Listener
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$dnsName`";CertificateThumbprint=`"$certThumbprint`"}"

# Verify Listener (we should have two listensers HTTP and HTTPS)
winrm enumerate winrm/config/Listener

# Configure Firewall Rule
#New-NetFirewallRule -DisplayName "Allow WinRM over HTTP"  -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

New-NetFirewallRule -DisplayName "Allow WinRM over HTTPS" -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow

# Enable and Start WinRM Service
Enable-PSRemoting -Force
Set-Service -Name WinRM -StartupType Automatic
Start-Service WinRM

# Enable Compatibility for HTTPS Listener
Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value $true


'@

$scriptPath = "C:\script.ps1"
Set-Content -Path $scriptPath -Value "$scriptContent"






# Path to the PowerShell script that you want to schedule
$scriptPath = "C:\script.ps1"

# Create a scheduled task trigger to run the task 5 minutes from now
$trigger = New-ScheduledTaskTrigger -At (Get-Date).AddMinutes(2) -Once

# Define the action that will run the PowerShell script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "$scriptPath *>> c:\error.txt"

# Define task settings to allow task to run even if no user is logged in
$settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the task to run with the given trigger, action, and settings
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "RunMyScriptAfter5Minutes" -Description "Runs a PowerShell script 2 minutes after task is created" -User "NT AUTHORITY\SYSTEM" -Settings $settings

Write-Host "Scheduled task has been created successfully."


    </powershell>
  EOF
}













# variable "my_ec2" {
#   type = map(object({
#     ami           : string
#     instance_type : string
#     group         : string  # Add a group for each instance (e.g., frontend, backend, database)
#     # subnet_id     : string
#     # num_instances      : number
#   }))
#   default = {
#     "frontend" = {
#       ami           = "ami-04f77c9cd94746b09"
#       instance_type = "t3.micro" 
#       group         = "frontend"
#       # subnet_id     = "aws_subnet.Public_subnet.id"
#       # num_instances        = 2
       
#     }
#     "backend" = {
#       ami           = "ami-04f77c9cd94746b09"
#       instance_type = "t3.micro" 
#       group         = "backend"
#       # subnet_id     = "aws_subnet.Public_subnet.id"
#       # num_instances        = 1
#     }
#     "database" = {
#       ami           = "ami-04f77c9cd94746b09"
#       instance_type = "t3.micro" 
#       group         = "database"
#       # subnet_id     = "aws_subnet.Public_subnet.id"
#       # num_instances        = 3
#     }
#   }
# }

# resource "aws_instance" "my_ec2" {
#   for_each      = var.my_ec2
#   ami           = each.value.ami
#   instance_type = each.value.instance_type
#   subnet_id     = aws_subnet.Public_subnet.id
#   vpc_security_group_ids =[aws_security_group.public_security_group.id ]
#   key_name = aws_key_pair.tf_public_key_pair.id    # put public key inside ec2
#   associate_public_ip_address = true
#   get_password_data = true    
#   tags = {
#     Name = each.value.group
#   }
#   user_data = <<-EOF
#     <powershell>
# $scriptContent = @'

# $publicIP = Invoke-RestMethod -Uri "https://api.ipify.org"
# $filePath = "C:\\public_ip.txt"
# Set-Content -Path $filePath -Value "$publicIp"

# # Define Variables
# $dnsName = "$publicIP"
# # Generate Self-Signed Certificate
# $cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $dnsName -KeyLength 2048 -NotAfter (Get-Date).AddYears(5) -FriendlyName "WinRM HTTPS Certificate"
# $certThumbprint = $cert.Thumbprint
# Write-Output "Certificate Thumbprint: $certThumbprint"

# # Create HTTPS Listener
# winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$dnsName`";CertificateThumbprint=`"$certThumbprint`"}"

# # Verify Listener (we should have two listensers HTTP and HTTPS)
# winrm enumerate winrm/config/Listener

# # Configure Firewall Rule
# #New-NetFirewallRule -DisplayName "Allow WinRM over HTTP"  -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

# New-NetFirewallRule -DisplayName "Allow WinRM over HTTPS" -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow

# # Enable and Start WinRM Service
# Enable-PSRemoting -Force
# Set-Service -Name WinRM -StartupType Automatic
# Start-Service WinRM

# # Enable Compatibility for HTTPS Listener
# Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value $true


# '@

# $scriptPath = "C:\script.ps1"
# Set-Content -Path $scriptPath -Value "$scriptContent"






# # Path to the PowerShell script that you want to schedule
# $scriptPath = "C:\script.ps1"

# # Create a scheduled task trigger to run the task 5 minutes from now
# $trigger = New-ScheduledTaskTrigger -At (Get-Date).AddMinutes(2) -Once

# # Define the action that will run the PowerShell script
# $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "$scriptPath *>> c:\error.txt"

# # Define task settings to allow task to run even if no user is logged in
# $settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -StartWhenAvailable

# # Register the task to run with the given trigger, action, and settings
# Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "RunMyScriptAfter5Minutes" -Description "Runs a PowerShell script 2 minutes after task is created" -User "NT AUTHORITY\SYSTEM" -Settings $settings

# Write-Host "Scheduled task has been created successfully."


#     </powershell>
#   EOF
# }



