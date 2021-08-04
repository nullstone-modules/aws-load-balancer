resource "aws_security_group" "lb" {
  name   = "${local.resource_name}/lb"
  vpc_id = local.vpc_id
  tags   = merge(data.ns_workspace.this.tags, { Name = "${local.resource_name}/lb" })
}

// This rule is always enabled; when we are listening on https, we still want to force http to https through redirect
resource "aws_security_group_rule" "lb-http-from-world" {
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_security_group_rule" "lb-http-to-app" {
  security_group_id        = aws_security_group.lb.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = aws_lb_target_group.this.port
  to_port                  = aws_lb_target_group.this.port
  source_security_group_id = var.app_metadata["security_group_id"]
}

resource "aws_security_group_rule" "app-http-from-lb" {
  security_group_id        = var.app_metadata["security_group_id"]
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = aws_lb_target_group.this.port
  to_port                  = aws_lb_target_group.this.port
  source_security_group_id = aws_security_group.lb.id
}
