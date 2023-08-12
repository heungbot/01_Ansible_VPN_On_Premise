# VPC
variable "APP_NAME" {
  default = "vpn-ansible"
}

variable "AZ" {
  default = ["ap-northeast-2a"]
}

# about VPC
variable "VPC_CIDR" {
  description = "The cidr block for the VPC."
  default     = "20.0.0.0/16"
}

variable "PUBLIC_CIDR" {
  description = "list public subnet cidr"
  default     = ["20.0.0.0/20"] # 0 ~ 63
}

variable "PRIVATE_CIDR" {
  description = "list private subnet cidr"
  default     = ["20.0.128.0/20"] # 64 ~ 127
}

# EC2 
variable "ADMIN_CIDR" {
  type    = list(any)
  default = ["3.3.3.3/32"]
}

variable "PUBLIC_KEY_PATH" {
  default = "/Users/bangdaeseonsaeng/.ssh/id_rsa.pub"
}

variable "BASTION_AMI" {
  default = "ami-0f2ce0bfb34039f29"
}

variable "BASTION_TYPE" {
  default = "t2.micro"
}

variable "ANSIBLE_AMI" {
  default = "ami-0f2ce0bfb34039f29"
}

variable "ANSIBLE_TYPE" {
  default = "t2.micro"
}


# VPN

variable "VPN_CLIENT_IP" {
  description = "change your vpn configured server's ip"
  default     = "1.2.3.4"
}

variable "VPN_CLIENT_CIDR" {
  default = "50.0.0.0/16"
}


