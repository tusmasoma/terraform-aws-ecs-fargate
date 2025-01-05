################################################################################
# NAT Gateway
################################################################################
resource "aws_eip" "this" {
  count      = var.is_nat_gateway ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
  tags = {
    Name      = "${var.env}-${var.system}-nat-eip"
    CreatedBy = var.created_by
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.is_nat_gateway ? 1 : 0
  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name      = "${var.env}-${var.system}-nat-gateway"
    CreatedBy = var.created_by
  }
}