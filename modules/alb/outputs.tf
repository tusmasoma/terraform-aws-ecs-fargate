output "load_balancer_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.this.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.this.zone_id
}