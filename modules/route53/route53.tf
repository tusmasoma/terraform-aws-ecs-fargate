################################################################################
# Route53 Record
################################################################################
data "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_route53_record" "domain_alias" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = data.aws_route53_zone.this.name
  type    = "A"

  alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = true
  }
}