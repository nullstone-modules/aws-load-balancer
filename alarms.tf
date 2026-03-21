resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  count = local.enable_alarms ? 1 : 0

  alarm_name          = "${local.resource_name}/unhealthy-hosts"
  alarm_description   = "Healthy host count dropped below ${var.alert_thresholds.min_healthy_host_count} on ${local.resource_name}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.alert_thresholds.min_healthy_host_count
  treat_missing_data  = "breaching"
  tags                = local.tags

  dimensions = {
    LoadBalancer = aws_lb.this.arn_suffix
    TargetGroup  = aws_lb_target_group.this.arn_suffix
  }

  alarm_actions = [local.notification_arn]
  ok_actions    = [local.notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "response_time" {
  count = local.enable_alarms ? 1 : 0

  alarm_name          = "${local.resource_name}/response-time"
  alarm_description   = "Average response time >= ${var.alert_thresholds.response_time}s on ${local.resource_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = var.alert_thresholds.response_time
  treat_missing_data  = "notBreaching"
  tags                = local.tags

  dimensions = {
    LoadBalancer = aws_lb.this.arn_suffix
    TargetGroup  = aws_lb_target_group.this.arn_suffix
  }

  alarm_actions = [local.notification_arn]
  ok_actions    = [local.notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "error_5xx" {
  count = local.enable_alarms ? 1 : 0

  alarm_name          = "${local.resource_name}/5xx-errors"
  alarm_description   = "5xx error count >= ${var.alert_thresholds.error_5xx_count} on ${local.resource_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = var.alert_thresholds.error_5xx_count
  treat_missing_data  = "notBreaching"
  tags                = local.tags

  dimensions = {
    LoadBalancer = aws_lb.this.arn_suffix
    TargetGroup  = aws_lb_target_group.this.arn_suffix
  }

  alarm_actions = [local.notification_arn]
  ok_actions    = [local.notification_arn]
}
