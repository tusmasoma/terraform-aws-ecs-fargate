data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.network.vpc_id
  vpc_cidr_block    = module.network.vpc_cidr_block
  env               = var.env
  system            = var.system
  created_by        = local.created_by
  public_subnet_ids = module.network.public_subnet_ids
}

module "ecs" {
  source                         = "../../modules/ecs"
  vpc_id                         = module.network.vpc_id
  region                         = data.aws_region.current.name
  env                            = var.env
  system                         = var.system
  created_by                     = local.created_by
  private_subnet_ids             = module.network.private_subnet_ids
  load_balancer_target_group_arn = module.alb.load_balancer_target_group_arn
}