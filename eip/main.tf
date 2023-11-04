
variable "eip_count" {
  default = 3
}

variable "name" {}

resource "aws_eip" "this" {
  count = var.eip_count

  domain = "vpc"
  tags = {
    Name = var.name
  }
}

output "eip_ids" {
  value = aws_eip.this.*.id
}

output "eip_allocation_ids" {
  value = aws_eip.this.*.allocation_id
}