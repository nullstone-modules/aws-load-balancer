output "load_balancers" {
  value = [
    {
      port             = aws_lb_target_group.this.port
      target_group_arn = aws_lb_target_group.this.arn
    }
  ]
}

locals {
  protocol         = var.enable_https ? lower(aws_lb_listener.https.protocol) : lower(aws_lb_listener.http.protocol)
  port             = var.enable_https ? aws_lb_listener.https.port : aws_lb_listener.http.port
  lb_subdomain     = [aws_lb.this.dns_name]
  lb_url           = "${local.protocol}://${local.lb_url}:${local.port}"
  vanity_subdomain = try(trimsuffix(aws_route53_record.alias[0].fqdn, "."), "")
  vanity_url       = "${local.protocol}://${local.vanity_subdomain}:${local.port}"
}

output "public_urls" {
  value = [
    {
      // Technically, we should always be able to hit the load balancer url directly
      // Let's return the vanity URL if we have one so the user is set up for success
      url = local.subdomain_zone_id != "" ? local.vanity_url : local.lb_url
    }
  ]
}
