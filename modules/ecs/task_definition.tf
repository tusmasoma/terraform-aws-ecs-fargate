################################################################################
# ECS Task Definition
################################################################################
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.env}-${var.system}-ecs-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "nginx"
        }
      }
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 80
        }
      ]
    }
  ])

  execution_role_arn = aws_iam_role.default.arn
}

################################################################################
# ECS Task Execution Role
################################################################################
data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:GetParameters",
      "kms:Decrypt"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "${var.env}-${var.system}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "default" {
  name   = "${var.env}-${var.system}-ecs-task-execution-policy"
  policy = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}