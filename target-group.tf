resource "aws_lb_target_group" "this" {
  name                 = local.resource_name
  port                 = var.app_metadata["service_port"]
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = local.vpc_id
  deregistration_delay = 10
  tags                 = data.ns_workspace.this.tags

  health_check {
    interval          = var.health_check.interval
    healthy_threshold = var.health_check.healthy_threshold
    enabled           = var.health_check.enabled
    path              = var.health_check.path
    matcher           = var.health_check.matcher
    timeout           = var.health_check.timeout
  }
}
