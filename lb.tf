resource "aws_lb" "this" {
  name               = local.resource_name
  internal           = false
  load_balancer_type = "application"
  subnets            = local.subnet_ids
  security_groups    = [aws_security_group.lb.id]
  enable_http2       = true
  ip_address_type    = "ipv4"
  tags               = local.tags

  access_logs {
    bucket  = module.logs_bucket.bucket_id
    enabled = true
  }
}
