resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}",
      }
    )
  )
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-public-${count.index}",
      }
    )
  )
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-private-${count.index}",
      }
    )
  )
}

# Private Subnets with nat gateway
resource "aws_subnet" "private_subnet_with_nat" {
  count             = var.enable_nat_gateway ? length(var.availability_zones) : 0
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks_with_nat, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-private-with-nat-${count.index}",
      }
    )
  )
}

# IGW for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = local.vpc_name
      }
    )
  )
}

# Public subnet traffic through IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    local.common_tags,
    tomap(
      {
        "Name" = "${local.vpc_name}-Public"
      }
    )
  )
}

# Route table and Subnet Associations
resource "aws_route_table_association" "internet_access" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.main.id
}