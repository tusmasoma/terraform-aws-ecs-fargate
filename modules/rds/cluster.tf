################################################################################
# RDS Cluster (Aurora)
################################################################################
resource "aws_rds_cluster" "this" {
  cluster_identifier              = "${var.env}-${var.system}-rds-cluster"
  availability_zones              = var.private_subnet_availability_zones
  engine                          = var.engine
  engine_version                  = var.engine_version
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id
  database_name                   = var.database_name
  master_username                 = var.master_username
  master_password                 = aws_ssm_parameter.this.value
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_subnet_group_name            = aws_db_subnet_group.this.id
  tags = {
    Name      = "${var.env}-${var.system}-rds-cluster"
    CreatedBy = var.created_by
  }
}

################################################################################
# RDS Cluster Parameter Group
################################################################################
resource "aws_rds_cluster_parameter_group" "this" {
  name   = "${var.env}-${var.system}-rds-cluster-parameter-group"
  family = var.family

  dynamic "parameter" {
    for_each = var.rds_params
    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = {
    Name      = "${var.env}-${var.system}-rds-cluster-parameter-group"
    CreatedBy = var.created_by
  }
}

################################################################################
# RDS Cluster SSM Parameter
################################################################################
resource "aws_ssm_parameter" "this" {
  name        = "/${var.env}/${var.system}/rds/master-password"
  description = "RDS master password"
  type        = "SecureString"
  value       = random_password.this.result
  tags = {
    Name      = "${var.env}-${var.system}-rds-master-password"
    CreatedBy = var.created_by
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!*-_=+"
}

################################################################################
# RDS Cluster Subnet Group
################################################################################
resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-${var.system}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name      = "${var.env}-${var.system}-rds-subnet-group"
    CreatedBy = var.created_by
  }
}

################################################################################
# RDS Cluster Security Group
################################################################################
resource "aws_security_group" "this" {
  name   = "${var.env}-${var.system}-rds-sg"
  vpc_id = var.vpc_id

  tags = {
    Name      = "${var.env}-${var.system}-rds-sg"
    CreatedBy = var.created_by
  }
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  description = "Allow all outbound traffic to the internet"
  tags = {
    Name      = "${var.env}-${var.system}-rds-sg-egress"
    CreatedBy = var.created_by
  }
}

resource "aws_security_group_rule" "this" {
  count                    = length(var.source_sg_ids)
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.source_sg_ids[count.index]
}