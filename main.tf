module "heungbot-vpc" {
  source       = "./heungbot-vpc"
  AZ           = var.AZ
  APP_NAME     = var.APP_NAME
  VPC_CIDR     = var.VPC_CIDR
  PUBLIC_CIDR  = var.PUBLIC_CIDR
  PRIVATE_CIDR = var.PRIVATE_CIDR
}

module "heungbot-ec2" {
  source            = "./heungbot-ec2"
  APP_NAME          = var.APP_NAME
  PUBLIC_KEY_PATH   = var.PUBLIC_KEY_PATH
  VPC_ID            = module.heungbot-vpc.vpc_id
  PUBLIC_SUBNET_ID  = module.heungbot-vpc.public_subnet_ids[0]
  PRIVATE_SUBNET_ID = module.heungbot-vpc.private_subnet_ids[0]
  ADMIN_CIDR        = var.ADMIN_CIDR
  BASTION_AMI       = var.BASTION_AMI
  BASTION_TYPE      = var.BASTION_TYPE
  ANSIBLE_AMI       = var.ANSIBLE_AMI
  ANSIBLE_TYPE      = var.ANSIBLE_TYPE
}

module "heungbot-vpn" {
  source             = "./heungbot-vpn"
  APP_NAME           = var.APP_NAME
  VPC_ID             = module.heungbot-vpc.vpc_id
  VPN_ROUTE_TABLE_ID = module.heungbot-vpc.public_route_table_id
  VPN_CLIENT_IP      = var.VPN_CLIENT_IP
  VPN_CLIENT_CIDR    = var.VPN_CLIENT_CIDR

}