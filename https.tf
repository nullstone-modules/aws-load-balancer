module "cert" {
  source  = "nullstone-modules/sslcert/aws"
  enabled = var.enable_https

  domain = {
    name    = local.subdomain_fqdn
    zone_id = local.subdomain_zone_id
  }

  tags = data.ns_workspace.this.tags
}

resource "aws_lb_listener" "http-redirect-to-https" {
  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = module.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group_rule" "lb-https-from-world" {
  count = var.enable_https ? 1 : 0

  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}
