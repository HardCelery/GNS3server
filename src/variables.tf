variable "key_name" {
  description = "The name of the EC2 key pair"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the existing subnet"
  type        = string
}

variable "private_ip" {
  description = "The private IP address you want to assign"
  type        = string
}

variable "allowed_cidr" {
  description = "Your public IP CIDR block for SSH/GNS3 access (ex: 0.0.0.0/0)"
  type        = string
}
