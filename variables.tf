variable "eip_count" {
  default = 1
}
variable "name" {
  default = "network-egress"
}
variable "region" {
  type = string
}
variable "env" {
  type = string
}
variable "single_nat_gateway" {
  default = true
}
variable "vpc_cidr" {
  type = string
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "enable_flow_log" {
  type = bool
}
variable "azs" {
  type = list(string)
}