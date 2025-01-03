################################################################################
# ECS Service
################################################################################
resource "aws_ecs_service" "this" {
  name                              = "${var.env}-${var.system}-ecs-service"
  cluster                           = aws_ecs_cluster.this.arn
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.this.id]

    subnets = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = var.load_balancer_target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

################################################################################
# Security Group for ECS Service On Fargate (Nginx)
################################################################################
resource "aws_security_group" "this" {
  name   = "${var.env}-${var.system}-nginx-sg"
  vpc_id = var.vpc_id

  tags = {
    Name      = "${var.env}-${var.system}-nginx-sg"
    CreatedBy = var.created_by
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.this.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  description = "Allow HTTP traffic from VPC endpoints"
  tags = {
    Name      = "${var.env}-${var.system}-nginx-sg-http"
    CreatedBy = var.created_by
  }
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  description = "Allow all outbound traffic to the internet"
  tags = {
    Name      = "${var.env}-${var.system}-nginx-sg-all"
    CreatedBy = var.created_by
  }
}