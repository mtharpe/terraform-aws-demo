#########################################
# Specify the provider and access details
#########################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.69.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">=0.73.0"
    }
  }
}

provider "aws" {}
provider "hcp" {}

#########################################
# Get all of the AMI's from AWS
#########################################
data "aws_ami" "windows" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"] # Canonical
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-kinetic-22.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#########################################
# HCP Packer Instance Data
#########################################

data "hcp_packer_image" "packer-run-tasks-demo" {
  bucket_name    = "packer-run-tasks-demo"
  channel        = "latest"
  cloud_provider = "aws"
  region         = "us-east-2"
}

# Then replace your existing references with
# data.hcp_packer_image.packer-run-tasks-demo.cloud_image_id

##############################
# Setup key for authentication
##############################
resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = var.public_key
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=5.0.0"

  name = "${var.user}-demo-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

  public_subnets = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

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
    cidr_blocks = ["10.0.0.0/16", "0.0.0.0/0"]
  }

  ingress {
    from_port   = 5985
    to_port     = 5986
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
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key
  }

  instance_type = "t2.large" # can be t2.large

  #ami                    = data.aws_ami.ubuntu.id
  ami                    = data.hcp_packer_image.packer-run-tasks-demo.cloud_image_id
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id              = module.vpc.public_subnets[0]
}