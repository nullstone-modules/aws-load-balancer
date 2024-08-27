locals {
  dims = tomap({
    "LoadBalancer" = aws_lb.this.arn_suffix
    "TargetGroup"  = aws_lb_target_group.this.arn_suffix
  })

  metric_name_prefix = "load-balancer/${random_string.resource_suffix.result}"

  metrics = [
    {
      name = "${local.metric_name_prefix}/hosts"
      type = "generic"
      unit = "count"

      mappings = {
        hosts_healthy = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "AWS/ApplicationELB"
          metric_name = "HealthyHostCount"
          dimensions  = local.dims
        }
        hosts_unhealthy = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "AWS/ApplicationELB"
          metric_name = "UnHealthyHostCount"
          dimensions  = local.dims
        }
      }
    },
    {
      name = "${local.metric_name_prefix}/requests"
      type = "generic"
      unit = "count"

      mappings = {
        requests_total = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/ApplicationELB"
          metric_name = "RequestCount"
          dimensions  = local.dims
        }
        requests_5xx = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/ApplicationELB"
          metric_name = "HTTPCode_Target_5XX_Count"
          dimensions  = local.dims
        }
        requests_4xx = {
          account_id  = local.account_id
          stat        = "Sum"
          namespace   = "AWS/ApplicationELB"
          metric_name = "HTTPCode_Target_4XX_Count"
          dimensions  = local.dims
        }
      }
    },
    {
      name = "${local.metric_name_prefix}/response"
      type = "duration"
      unit = "seconds"

      mappings = {
        response_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "AWS/ApplicationELB"
          metric_name = "TargetResponseTime"
          dimensions  = local.dims
        }
        response_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "AWS/ApplicationELB"
          metric_name = "TargetResponseTime"
          dimensions  = local.dims
        }
        response_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "AWS/ApplicationELB"
          metric_name = "TargetResponseTime"
          dimensions  = local.dims
        }
      }
    }
  ]
}
