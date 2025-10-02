resource "aws_globalaccelerator_accelerator" "this" {
  count = var.enable_global_accelerator ? 1 : 0

  name            = local.resource_name
  ip_address_type = "IPV4"
  enabled         = true
  tags            = local.tags

  attributes {
    flow_logs_enabled   = true
    flow_logs_s3_bucket = module.logs_bucket.bucket_id
    flow_logs_s3_prefix = "accelerator-flow-logs/"
  }
}

locals {
  ga_arn      = var.enable_global_accelerator ? aws_globalaccelerator_accelerator.this.arn : ""
  ga_dns_name = var.enable_global_accelerator ? aws_globalaccelerator_accelerator.this.dns_name : ""
  ga_zone_id  = var.enable_global_accelerator ? aws_globalaccelerator_accelerator.this.hosted_zone_id : ""
}

resource "aws_globalaccelerator_listener" "this_http" {
  count = var.enable_global_accelerator ? 1 : 0

  accelerator_arn = local.ga_arn
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "this_http" {
  count = var.enable_global_accelerator ? 1 : 0

  listener_arn                  = aws_globalaccelerator_listener.this_http[count.index].arn
  traffic_dial_percentage       = 100
  health_check_protocol         = "TCP"
  health_check_port             = 80
  health_check_interval_seconds = 30
  threshold_count               = 3

  endpoint_configuration {
    endpoint_id = aws_lb.this.arn
    weight      = 100
  }
}

resource "aws_globalaccelerator_listener" "this_https" {
  count = var.enable_global_accelerator && var.enable_https ? 1 : 0

  accelerator_arn = local.ga_arn
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "this_https" {
  count = var.enable_global_accelerator && var.enable_https ? 1 : 0

  listener_arn                  = aws_globalaccelerator_listener.this_https[count.index].arn
  traffic_dial_percentage       = 100
  health_check_protocol         = "TCP"
  health_check_port             = 443
  health_check_interval_seconds = 30
  threshold_count               = 3

  endpoint_configuration {
    endpoint_id = aws_lb.this.arn
    weight      = 100
  }
}
