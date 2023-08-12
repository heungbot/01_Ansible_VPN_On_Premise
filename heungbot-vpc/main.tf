# ECS Task가 target group으로 등록되지 않는 문제 발생
# + terraform code 이름 수정

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.APP_NAME}-vpc"
  }
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.APP_NAME}-igw"
  }
}

# EIP for NAT
resource "aws_eip" "nat-gw-ip" {
  count      = length(var.AZ)
  depends_on = [aws_internet_gateway.aws-igw]
}

resource "aws_nat_gateway" "aws-nat-gw" {
  count         = length(var.AZ)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat-gw-ip.*.id, count.index)
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.PUBLIC_CIDR, count.index)
  availability_zone       = element(var.AZ, count.index)
  count                   = length(var.PUBLIC_CIDR)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.APP_NAME}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.PRIVATE_CIDR)
  cidr_block        = element(var.PRIVATE_CIDR, count.index)
  availability_zone = element(var.AZ, count.index)

  tags = {
    Name = "${var.APP_NAME}-private-subnet-${count.index + 1}"
  }
}

# public routing table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.APP_NAME}-routing-table-public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.PUBLIC_CIDR)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# private routing table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.APP_NAME}-routing-table-private"
  }
}

resource "aws_route" "private" {
  count                  = length(aws_nat_gateway.aws-nat-gw.*.id)
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_nat_gateway.aws-nat-gw.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.PRIVATE_CIDR)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}



