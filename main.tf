module "eip" {
  source    = "./eip"
  eip_count = var.eip_count
  name      = var.name
}

module "transit_gateway" {
  source                                 = "./transit-gateway"
  name                                   = var.name
  description                            = "Egress Transit Gateway"
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true
  enable_mutlicast_support               = false
  enable_vpn_ecmp_support                = false
  enable_dns_support                     = true
  enable_auto_accept_shared_attachments  = true
}

module "vpc" {
  source             = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//"
  cidr               = var.vpc_cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  azs                = var.azs
  name               = "${var.name}-vpc"
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  reuse_nat_ips       = true               # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = module.eip.eip_ids # <= IPs specified here as input to the module

  enable_dns_hostnames   = true
  enable_dns_support     = true
  one_nat_gateway_per_az = false

  enable_flow_log                      = try(var.enable_flow_log, false)
  create_flow_log_cloudwatch_log_group = try(var.enable_flow_log, false)
  create_flow_log_cloudwatch_iam_role  = try(var.enable_flow_log, false)
  flow_log_max_aggregation_interval    = 60

  private_subnet_tags = {
    Name = "${var.name}-vpc-private-subnet"
  }
  public_subnet_tags = {
    Name = "${var.name}-vpc-public-subnet"
  }
  private_route_table_tags = {
    Name = "${var.name}-vpc-private-rt"
  }
  public_route_table_tags = {
    Name = "${var.name}-vpc-public-rt"
  }
  tags = {
    Name = "${var.name}-vpc"
  }
}