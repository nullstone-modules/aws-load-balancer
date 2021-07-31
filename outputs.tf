output "load_balancers" {
  value = [
    {
      port              = aws_lb_target_group.this.port
      target_group_arn  = aws_lb_target_group.this.arn
      security_group_id = aws_security_group.lb.id
    }
  ]
}
