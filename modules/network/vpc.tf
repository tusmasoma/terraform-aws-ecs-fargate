################################################################################
# VPC
################################################################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name      = "${var.env}-${var.system}-vpc"
    CreatedBy = var.created_by
  }
}