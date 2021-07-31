resource "aws_lb_target_group" "this" {
  name                 = local.resource_name
  port                 = var.service_port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = local.vpc_id
  deregistration_delay = 30
  tags                 = data.ns_workspace.this.tags

  health_check {
    enabled = var.health_check.enabled
    path    = var.health_check.path
    matcher = var.health_check.matcher
  }
}
