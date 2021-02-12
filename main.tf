#########################################
# Specify the provider and access details
#########################################
provider "aws" {
  region = var.aws_region
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##############################
# Setup key for authentication
##############################
resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = var.public_key
}


resource "aws_iam_policy" "policy" {
  name        = "${var.user}-policy"
  description = "${var.user}-Demo-Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "vpc" {
  source  = "app.terraform.io/mtharpe/vpc/aws"
  version = ">=1.0.0"

  name = "${var.user}-demo-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "Demo"
  }
}

########################################
# List all availability zones to be used
########################################
data "aws_availability_zones" "available" {}

########################
# Default Security group
########################
resource "aws_security_group" "default" {
  name        = "${var.user}-demo-tfe default sg"
  description = "Used in the terraform"
  vpc_id      = module.vpc.vpc_id

  # SSH access from the VPC and LocalIP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"] # This will break policy!
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
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
    Name = "${var.user}-web-01"
    # Environment = "Demo"
  }

  instance_type = "t2.large" # can be t2.large

  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id              = module.vpc.public_subnets[0]
}