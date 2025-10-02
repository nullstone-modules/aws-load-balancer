locals {
  alias_name    = var.enable_global_accelerator ? local.ga_dns_name : aws_lb.this.dns_name
  alias_zone_id = var.enable_global_accelerator ? local.ga_zone_id : aws_lb.this.zone_id
}

resource "aws_route53_record" "alias" {
  count = local.subdomain_zone_id != "" ? 1 : 0

  zone_id = local.subdomain_zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = local.alias_name
    zone_id                = local.alias_zone_id
    evaluate_target_health = false
  }
}
