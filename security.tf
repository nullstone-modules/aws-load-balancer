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
