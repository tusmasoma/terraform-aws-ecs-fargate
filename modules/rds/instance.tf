################################################################################
# RDS Cluster Instance
################################################################################
resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.env}-${var.system}-rds-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_type
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  tags = {
    Name      = "${var.env}-${var.system}-rds-instance-${count.index}"
    CreatedBy = var.created_by
  }
}
