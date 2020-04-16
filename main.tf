#########################################
# Specify the provider and access details
#########################################
provider "aws" {
  region  = var.aws_region
  version = "~> 2.0"
}

##############################
# Setup key for authentication
##############################
resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = var.public_key
}

########################################
# List all availability zones to be used
########################################
data "aws_availability_zones" "available" {
}

########################
# Default Security group
########################
resource "aws_security_group" "default" {
  name        = "demo-tfe default sg"
  description = "Used in the terraform"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # SSH access from the VPC and LocalIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
  }

  ingress {
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
  }

  # RDP access from the VPC and LocalIP
  ingress {
    from_port   = 3389 
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
  }

  # HTTPS access from the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
  }

  # HTTP Jenkins 8080 access from the VPC
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############
# Web Instance
##############
resource "aws_instance" "web-01" {
  tags = {
    Name = "mtharpe-web-01"
  }

  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "ubuntu"
    private_key = var.private_key
  }

  instance_type = "t2.micro"

  ami = var.aws_ami_linux
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init to finish...'; sleep 1; done",
      "sudo apt update && sleep $((RANDOM % 10)) && sudo apt update",
      "sudo apt install apache2 -y"
    ]
  }
}

#####################
# Management Instance
#####################
resource "aws_instance" "mgmt-01" {
  tags = {
    Name = "mtharpe-mgmt-01"
  }

  connection {
    host     = aws_instance.mgmt-01.public_ip
    type     = "winrm"
    user     = var.instance_username
    password = var.instance_password
  }

  instance_type           = "t2.medium"
  source_dest_check       = true
  disable_api_termination = false

  ami = var.aws_ami_windows
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  user_data = <<EOF
<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
net user ${var.instance_username} '${var.instance_password}' /add /y
net localgroup administrators ${var.instance_username} /add
</powershell>
EOF

  provisioner "remote-exec" {
    inline = [
      "powershell -command Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole",
      "powershell -command Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer",
      "powershell -command Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures",
      "powershell -command Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors",
      "powershell -command Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect",
      "powershell -command Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment"
    ]
  }
}

###################
# Jenkins Instances
###################
resource "aws_instance" "jenkins-01" {
  tags = {
    Name = "mtharpe-jenkins-01"
  }

  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "ubuntu"
    private_key = var.private_key
  }

  instance_type           = "t2.micro"
  source_dest_check       = true
  disable_api_termination = false

  ami = var.aws_ami_linux
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[1]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init to finish...'; sleep 1; done",
      "sudo apt update && sleep $((RANDOM % 10)) && sudo apt update",
      "sudo apt install zip -y"
    ]
  }
}

###################
# Database Instance
###################
resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  name                   = "mtharpe-webdb"
  username               = "dbuser"
  password               = "dbpassword1"
  vpc_security_group_ids = [aws_security_group.default.id]
  db_subnet_group_name   = data.terraform_remote_state.vpc.outputs.database_subnet_group
  skip_final_snapshot    = true
}

