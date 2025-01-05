resource "aws_lb_target_group" "this" {
  name        = "${var.env}-${var.system}-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.this]
  tags = {
    Name      = "${var.env}-${var.system}-tg"
    CreatedBy = var.created_by
  }
}