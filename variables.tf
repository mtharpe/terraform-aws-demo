variable "user" {
  description = "This is going to be the Org username"
  type        = string
}

variable "public_key" {
  description = "Public key info"
  type        = string
  sensitive   = true
}

variable "private_key" {
  description = "Private key info"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  type        = string
  default     = "mtharpe-demo-terraform"
}

variable "aws_instance_username" {
  type    = string
  default = ""
}

variable "aws_instance_password" {
  default   = ""
  type      = string
  sensitive = true
}

