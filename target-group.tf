locals {
  stickinesses = {
    "off" : {
      enabled         = false
      type            = "lb_cookie"
      cookie_name     = null
      cookie_duration = null
    },
    "duration" : {
      enabled         = true
      type            = "lb_cookie"
      cookie_name     = null
      cookie_duration = var.sticky_session_duration
    },
    "application" : {
      enabled         = true
      type            = "app_cookie"
      cookie_name     = var.sticky_session_cookie_name
      cookie_duration = null
    }
  }
  effective_stickiness = local.stickinesses[var.sticky_session_type]
}

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

  dynamic "stickiness" {
    for_each = [local.effective_stickiness]

    content {
      enabled         = stickiness.value.enabled
      type            = stickiness.value.type
      cookie_name     = stickiness.value.cookie_name
      cookie_duration = stickiness.value.cookie_duration
    }
  }
}
