################################################################################
# Subnet
################################################################################
data "aws_availability_zones" "this" {}

resource "aws_subnet" "public" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name      = "${var.env}-${var.system}-public-subnet-${count.index}"
    CreatedBy = var.created_by
  }
}

resource "aws_subnet" "private" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index + var.subnet_count)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  tags = {
    Name      = "${var.env}-${var.system}-private-subnet-${count.index}"
    CreatedBy = var.created_by
  }
}