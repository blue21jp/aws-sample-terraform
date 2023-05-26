# VPC
resource "aws_vpc" "main" {
  cidr_block           = local.global.base_vpc.cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${local.global.base_vpc.prefix}-main"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-main"
  }
}

# Subnet public
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.global.base_vpc.public[count.index]
  availability_zone       = data.aws_availability_zone.az[count.index].name
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.global.base_vpc.prefix}-public-${data.aws_availability_zone.az[count.index].name_suffix}"
  }
}

# Routes Table : public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${local.global.base_vpc.prefix}-public"
  }
}
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Subnet private
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.global.base_vpc.private[count.index]
  availability_zone = data.aws_availability_zone.az[count.index].name
  tags = {
    Name = "${local.global.base_vpc.prefix}-private-${data.aws_availability_zone.az[count.index].name_suffix}"
  }
}

# Routes Table : private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-private"
  }
}
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# s3 endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private.id
}
