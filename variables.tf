variable "user" {
  description = "This is going to be the Org username"
}

variable "public_key" {
  description = "Public key info"
  sensitive   = true
}

variable "private_key" {
  description = "Private key info"
  sensitive   = true
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default     = "mtharpe-demo-terraform"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "aws_instance_username" {
  default = ""
}

variable "aws_instance_password" {
  default   = ""
  sensitive = true
}

