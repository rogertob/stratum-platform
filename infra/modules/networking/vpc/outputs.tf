output "vpc_id" {
  value = aws_vpc.this.id
}

output "app_subnets" {
  value = {
    for k, subnet in aws_subnet.app : k => subnet.id
  }
}

output "public_subnets" {
  value = {
    for k, subnet in aws_subnet.web : k => subnet.id
  }
}

output "data_subnets" {
  value = {
    for k, subnet in aws_subnet.data : k => subnet.id
  }
}

output "nat_gw_id" {
  value = aws_nat_gateway.this["enabled"].id
}

output "app_rtb_id" {
  value = aws_route_table.app.id
}

output "public_rtb_id" {
  value = aws_route_table.web.id
}

output "data_rtb_id" {
  value = aws_route_table.data.id
}