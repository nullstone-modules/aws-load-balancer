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

locals {
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = local.ssl_policy
  certificate_arn   = local.certificate_arn
  tags              = local.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group_rule" "lb-https-from-world" {
  count = var.enable_https && var.is_publicly_accessible ? 1 : 0

  security_group_id = aws_security_group.lb.id
  cidr_blocks       = local.allow_ips
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_security_group_rule" "lb-https-from-vpc" {
  count = var.enable_https && !var.is_publicly_accessible ? 1 : 0

  security_group_id = aws_security_group.lb.id
  cidr_blocks       = [local.vpc_cidr]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}
