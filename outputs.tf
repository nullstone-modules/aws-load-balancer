output "load_balancers" {
  value = [
    {
      port             = aws_lb_target_group.this.port
      target_group_arn = aws_lb_target_group.this.arn
    }
  ]
}

locals {
  protocol         = var.enable_https ? lower(aws_lb_listener.https[0].protocol) : lower(aws_lb_listener.http[0].protocol)
  port             = var.enable_https ? aws_lb_listener.https[0].port : aws_lb_listener.http[0].port
  lb_subdomain     = aws_lb.this.dns_name
  lb_url           = "${local.protocol}://${local.lb_subdomain}:${local.port}"
  accelerator_url  = "${local.protocol}://${local.ga_dns_name}:${local.port}"
  vanity_subdomain = try(trimsuffix(aws_route53_record.alias[0].fqdn, "."), "")
  vanity_url       = "${local.protocol}://${local.vanity_subdomain}:${local.port}"

  urls = [
    {
      // Technically, we should always be able to hit the load balancer or accelerator url directly
      // Let's return the vanity URL if we have one so the user is set up for success
      url = local.subdomain_zone_id != "" ? local.vanity_url : (var.enable_global_accelerator ? local.accelerator_url : local.lb_url)
    }
  ]
}

output "public_urls" {
  value = var.is_publicly_accessible ? local.urls : []
}

output "private_urls" {
  value = !var.is_publicly_accessible ? local.urls : []
}

output "metrics" {
  value = [
    for m in local.metrics : {
      name     = m.name
      type     = m.type
      unit     = m.unit
      mappings = jsonencode(m.mappings)
    }
  ]
}
