variable "name" {
  type = string
}
variable "description" {
  type = string
}
variable "transit_gateway_id" {
  type = string
}
variable "tgw_routes" {
  default = []
  type    = any
}
variable "tgw_blackhole" {
  default = ""
  type    = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "dns_support" {
  default = true
}
variable "ipv6_support" {
  default = false
}
variable "appliance_mode_support" {
  default = false
}
variable "table_association" {
  default = true
}
variable "table_propagation" {
  default = true
}
variable "route_table_ids" {
  type = list(string)
}
variable "vpc_tg_route_cidr_block" {
  default = ""
}