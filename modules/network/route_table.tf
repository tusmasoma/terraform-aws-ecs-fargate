################################################################################
# Public Route Table
################################################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name      = "${var.env}-${var.system}-route-table"
    CreatedBy = var.created_by
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################################################################################
# Private Route Table
################################################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  # set route if nat exists
  dynamic "route" {
    for_each = var.is_nat_gateway ? [aws_nat_gateway.this] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = route.value[0].id
    }
  }
  tags = {
    Name      = "${var.env}-${var.system}-private-route-table"
    CreatedBy = var.created_by
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}