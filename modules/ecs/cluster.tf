################################################################################
# ECS Cluster
################################################################################
resource "aws_ecs_cluster" "this" {
  name = "${var.env}-${var.system}-ecs-cluster"
  tags = {
    Name      = "${var.env}-${var.system}-ecs-cluster"
    CreatedBy = var.created_by
  }
}