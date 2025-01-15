################################################################################
# Cloudwatch Log For ECS
################################################################################
resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.env}-${var.system}-ecs-task"
  retention_in_days = 180

  tags = {
    Name      = "${var.env}-${var.system}-ecs-task"
    CreatedBy = var.created_by
  }
}