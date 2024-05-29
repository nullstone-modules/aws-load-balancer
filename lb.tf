resource "aws_lb" "this" {
  name               = local.resource_name
  internal           = false
  load_balancer_type = "application"
  subnets            = local.subnet_ids
  security_groups    = [aws_security_group.lb.id]
  enable_http2       = true
  ip_address_type    = "ipv4"
  tags               = local.tags

  desync_mitigation_mode     = var.desync_mitigation_mode
  drop_invalid_header_fields = var.drop_invalid_header_fields
  idle_timeout               = var.idle_timeout

  access_logs {
    bucket  = module.logs_bucket.bucket_id
    enabled = true
  }
}
