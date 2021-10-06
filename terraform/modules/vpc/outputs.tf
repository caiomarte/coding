output "VPCID" {
    description = "A reference to the created VPC."
    value = aws_vpc.VPC.id
}

output "VpcCIDR" {
    description = "VPC CIDR block."
    value = aws_vpc.VPC.cidr_block
}

output "PublicSubnets" {
    description = "A list of the public subnets."
    value = aws_subnet.PublicSubnet.*.id
}

output "PrivateSubnetsApp" {
    description = "A list of the app private subnets."
    value = aws_subnet.PrivateAppSubnet.*.id
}

output "PrivateSubnetsDB" {
    description = "A list of the DB private subnets."
    value = aws_subnet.PrivateDBSubnet.*.id
}

output "AllPrivateSubnets" {
    description = "A list of the private subnets."
    value = concat(aws_subnet.PrivateAppSubnet.*.id, aws_subnet.PrivateDBSubnet.*.id)
}

output "AllSubnets" {
    description = "A list of all subnets."
    value = concat(aws_subnet.PublicSubnet.*.id, aws_subnet.PrivateAppSubnet.*.id, aws_subnet.PrivateDBSubnet.*.id)
}

output "PublicRouteTables" {
    description = "A list of the public route tables."
    value = aws_route_table.PublicRouteTable.*.id
}

output "PrivateRouteTables" {
    description = "A list of the private route tables."
    value = concat(aws_route_table.PrivateAppRouteTable.*.id, aws_route_table.PrivateDBRouteTable.*.id)
}

output "AllRouteTables" {
    description = "A list of all route tables."
    value = concat(aws_route_table.PublicRouteTable.*.id, aws_route_table.PrivateAppRouteTable.*.id, aws_route_table.PrivateDBRouteTable.*.id)
}

### Public
output "PublicSubnet1" {
    description = "A reference to the public subnet in the 1st Availability Zone."
    value = aws_subnet.PublicSubnet.*.id[0]
}

output "PublicSubnet2" {
    description = "A reference to the public subnet in the 2nd Availability Zone."
    value = aws_subnet.PublicSubnet.*.id[1]
}

output "PublicSubnet3" {
    description = "A reference to the public subnet in the 3rd Availability Zone."
    value = aws_subnet.PublicSubnet.*.id[2]
}

output "PublicSubnet1CIDR" {
    description = "A reference to the public subnet CIDR in the 1st Availability Zone."
    value = var.PublicSubnetsCIDRs[0]
}

output "PublicSubnet2CIDR" {
    description = "A reference to the public subnet CIDR in the 2nd Availability Zone."
    value = var.PublicSubnetsCIDRs[1]
}

output "PublicSubnet3CIDR" {
    description = "A reference to the public subnet CIDR in the 3rd Availability Zone."
    value = var.PublicSubnetsCIDRs[2]
}

### Private App
output "PrivateAppSubnet1" {
    description = "A reference to the private App subnet in the 1st Availability Zone."
    value = aws_subnet.PrivateAppSubnet.*.id[0]
}

output "PrivateAppSubnet2" {
    description = "A reference to the private App subnet in the 2nd Availability Zone."
    value = aws_subnet.PrivateAppSubnet.*.id[1]
}

output "PrivateAppSubnet3" {
    description = "A reference to the private App subnet in the 3rd Availability Zone."
    value = aws_subnet.PrivateAppSubnet.*.id[2]
}

output "PrivateAppSubnet1CIDR" {
    description = "A reference to the private App subnet CIDR in the 1st Availability Zone."
    value = var.PrivateAppSubnetsCIDRs[0]
}

output "PrivateAppSubnet2CIDR" {
    description = "A reference to the private App subnet CIDR in the 2nd Availability Zone."
    value = var.PrivateAppSubnetsCIDRs[1]
}

output "PrivateAppSubnet3CIDR" {
    description = "A reference to the private App subnet CIDR in the 3rd Availability Zone."
    value = var.PrivateAppSubnetsCIDRs[2]
}

### Private DB
output "PrivateDBSubnet1" {
    description = "A reference to the private DB subnet in the 1st Availability Zone."
    value = aws_subnet.PrivateDBSubnet.*.id[0]
}

output "PrivateDBSubnet2" {
    description = "A reference to the private DB subnet in the 2nd Availability Zone."
    value = aws_subnet.PrivateDBSubnet.*.id[1]
}

output "PrivateDBSubnet3" {
    description = "A reference to the private DB subnet in the 3rd Availability Zone."
    value = aws_subnet.PrivateDBSubnet.*.id[2]
}

output "PrivateDBSubnet1CIDR" {
    description = "A reference to the private DB subnet CIDR in the 1st Availability Zone."
    value = var.PrivateDBSubnetsCIDRs[0]
}

output "PrivateDBSubnet2CIDR" {
    description = "A reference to the private DB subnet CIDR in the 2nd Availability Zone."
    value = var.PrivateDBSubnetsCIDRs[1]
}

output "PrivateDBSubnet3CIDR" {
    description = "A reference to the private DB subnet CIDR in the 3rd Availability Zone."
    value = var.PrivateDBSubnetsCIDRs[2]
}

### Nat Gateway
output "NatGateway1EIP" {
    description = "A reference to the NAT Gateway public IP in the 1st Availability Zone."
    value = aws_eip.NatGatewayEIP.*.id[0]
}

output "NatGateway2EIP" {
    description = "A reference to the NAT Gateway public IP in the 2nd Availability Zone."
    value = var.CreateNatOnlyOnOneAZ ? null : aws_eip.NatGatewayEIP.*.id[1]
}

output "NatGateway3EIP" {
    description = "A reference to the NAT Gateway public IP in the 3rd Availability Zone."
    value = var.CreateNatOnlyOnOneAZ ? null : aws_eip.NatGatewayEIP.*.id[2]
}