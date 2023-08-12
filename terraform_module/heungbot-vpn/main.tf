# virtual gateway
resource "aws_vpn_gateway" "vgw" {
  vpc_id = var.VPC_ID

  tags = {
    Name = "${var.APP_NAME}-vgw"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = var.VPC_ID
  vpn_gateway_id = aws_vpn_gateway.vgw.id
}

# customer gateway
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = var.VPN_CLIENT_IP
  type       = "ipsec.1"

  tags = {
    Name = "${var.APP_NAME}-cgw"
  }
}
# connection
resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
}

# connection route
resource "aws_vpn_connection_route" "idc" {
  destination_cidr_block = var.VPN_CLIENT_CIDR
  vpn_connection_id      = aws_vpn_connection.main.id
}

# route propagation
resource "aws_vpn_gateway_route_propagation" "route_propagation" {
  vpn_gateway_id = aws_vpn_gateway.vgw.id
  route_table_id = var.VPN_ROUTE_TABLE_ID
}

# apply 이후 idc route talbe 수정
# VPC_CIDR로 향하는 요청을 CGW를 거치도록