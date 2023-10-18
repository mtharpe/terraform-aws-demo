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

variable "aws_instance_username" {
  description = "Username for the AWS instance"
  default     = ""
}

variable "aws_instance_password" {
  description = "Password for the AWS instance"
  default     = ""
  sensitive   = true
}
