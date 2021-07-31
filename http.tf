resource "aws_lb_listener" "http" {
  count = var.enable_https ? 0 : 1

  load_balancer_arn = aws_lb.this.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
