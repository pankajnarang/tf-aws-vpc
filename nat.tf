#Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "nat_gateway_eip" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  depends_on = [
    aws_route_table_association.internet_access
  ]

  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-nat-eip-${count.index}",
      }
    )
  )
}

# Creating Nat Gateway in each subnet provided in values file
resource "aws_nat_gateway" "nat_gateway" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  depends_on = [
    aws_eip.nat_gateway_eip
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.nat_gateway_eip[count.index].id

  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public_subnet[count.index].id
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-natGateway-${count.index}",
      }
    )
  )
}

# Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "nat_gateway_rt" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  depends_on = [
    aws_nat_gateway.nat_gateway
  ]

  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-natGateway-rt-${count.index}",
      }
    )
  )
}

# Creating an Route Table Association of the NAT Gateway
resource "aws_route_table_association" "nat_gateway_rt_association" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  depends_on = [
    aws_route_table.nat_gateway_rt
  ]

  subnet_id = aws_subnet.private_subnet_with_nat[count.index].id

  route_table_id = aws_route_table.nat_gateway_rt[count.index].id
}