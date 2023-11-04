module "network_egress" {
  source             = "../"
  name               = "network-egress"
  eip_count          = 1
  single_nat_gateway = true
  env                = "test"
  region             = "us-east-1"
  vpc_cidr           = "192.168.8.0/21"
  azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets    = ["192.168.8.0/25", "192.168.8.128/25", "192.168.9.0/25"]
  public_subnets     = ["192.168.10.0/25", "192.168.10.128/25", "192.168.11.0/25"]
  enable_flow_log    = true
}

module "egress_vpc_attachment" {
  source                  = "../vpc-attachment"
  name                    = "network-egress"
  description             = "Central hub for multi-account landing zone accounts and egress traffic out to the Internet"
  vpc_tg_route_cidr_block = "10.0.0.0/8"
  tgw_blackhole           = "192.168.8.0/21"
  tgw_routes              = ["0.0.0.0/0", "10.0.0.0/8"]
  transit_gateway_id      = module.network_egress.transit_gateway_id
  route_table_ids         = module.network_egress.public_route_table_ids
  vpc_id                  = module.network_egress.vpc_id
  subnet_ids              = module.network_egress.private_subnets
  dns_support             = true
  ipv6_support            = false
  appliance_mode_support  = false
  table_association       = true
  table_propagation       = false
  tags = {
    "Name" = "network-egress"
  }
}

module "dmz_vpc_attachment" {
  source                  = "../vpc-attachment"
  name                    = "dmz"
  description             = "DMZ VPC Attachment to Transit Gateway"
  transit_gateway_id      = module.network_egress.transit_gateway_id
  route_table_ids         = module.dmz_vpc.public_route_table_ids
  vpc_tg_route_cidr_block = "10.0.0.0/8"
  vpc_id                  = module.dmz_vpc.vpc_id
  subnet_ids              = module.dmz_vpc.public_subnets
  dns_support             = true
  ipv6_support            = false
  table_propagation       = true
  table_association       = true
  tgw_blackhole           = ""
  tgw_routes              = []
  tags = {
    "Name" = "network-egress"
  }}

module "dev_vpc_attachment" {
  source                  = "../vpc-attachment"
  name                    = "dev"
  description             = "DEV VPC Attachment to Transit Gateway"
  transit_gateway_id      = module.network_egress.transit_gateway_id
  route_table_ids         = module.dev_vpc.public_route_table_ids
  vpc_tg_route_cidr_block = "10.0.0.0/8"
  vpc_id                  = module.dev_vpc.vpc_id
  subnet_ids              = module.dev_vpc.private_subnets
  dns_support             = true
  ipv6_support            = false
  table_propagation       = true
  table_association       = true
  tgw_blackhole           = ""
  tgw_routes              = []
  tags = {
    "Name" = "network-egress"
  }
}

module "test_vpc_attachment" {
  source                  = "../vpc-attachment"
  name                    = "test"
  description             = "Test VPC Attachment to Transit Gateway"
  transit_gateway_id      = module.network_egress.transit_gateway_id
  route_table_ids         = module.test_vpc.public_route_table_ids
  vpc_tg_route_cidr_block = "10.0.0.0/8"
  vpc_id                  = module.test_vpc.vpc_id
  subnet_ids              = module.test_vpc.private_subnets
  dns_support             = true
  ipv6_support            = false
  table_propagation       = true
  table_association       = true
  tgw_blackhole           = ""
  tgw_routes              = []
  tags = {
    "Name" = "network-egress"
  }}

#############################################

module "dmz_vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  name           = "dmz-vpc"
  cidr           = "10.222.0.0/16"
  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets = ["10.222.1.0/24", "10.222.2.0/24", "10.222.3.0/24"]
}

module "dev_vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "dev-vpc"
  cidr            = "10.3.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
}

module "test_vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "test-vpc"
  cidr            = "10.2.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}