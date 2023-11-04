output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}
output "eip_ids" {
  value = module.eip.eip_ids
}
output "eip_allocation_ids" {
  value = module.eip.eip_allocation_ids
}
output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}