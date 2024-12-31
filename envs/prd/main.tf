data "aws_caller_identity" "current" {}

locals {
  created_by = "Terraform - ${data.aws_caller_identity.current.account_id}"
}

module "network" {
  source         = "../../modules/network"
  vpc_cidr       = "10.0.0.0/16"
  env            = var.env
  system         = var.system
  is_nat_gateway = true
  created_by     = local.created_by
  subnet_count   = 2
}