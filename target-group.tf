resource "aws_lb_target_group" "this" {
  name                 = "${local.resource_name}-${var.app_metadata["service_port"]}"
  port                 = var.app_metadata["service_port"]
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = local.vpc_id
  deregistration_delay = 10
  tags                 = local.tags

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    interval            = var.health_check_interval
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    enabled             = var.health_check_enabled
    path                = var.health_check_path
    matcher             = var.health_check_matcher
    timeout             = var.health_check_timeout
  }
}
