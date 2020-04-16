variable "public_key" {
  description = "Public key info"
}

variable "private_key" {
  description = "Private key info"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "terraform"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "aws_ami_linux" {
  default = "ami-0fc20dd1da406780b"
}

variable "aws_ami_windows" {
  default = "ami-067317d2d40fd5919"
}

variable "instance_username" {
  default = ""
}

variable "instance_password" {
  default = ""
}

variable "local_ip" {
  default = "68.44.31.188/32"
}

# Chef global vars
variable "chef_environment" {
  default = "_default"
}

variable "server_runlist" {
  default = "server::default"
}

variable "chef_server_url" {
  default = "https://api.chef.io/organizations/axis"
}

variable "chef_username" {
  default = "mtharpe"
}

variable "chef_pem" {
  default = ""
}

