variable "user" {
  description = "This is going to be the Org username"
}

variable "public_key" {
  description = "Public key info"
}

variable "private_key" {
  description = "Private key info"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "mtharpe-demo-terraform"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "aws_ami_linux" {
  default = "ami-07c1207a9d40bc3bd"
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

