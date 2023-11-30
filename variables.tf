variable app_metadata {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable enable_https {
  description = "Enable this to serve up HTTPS traffic. Requires subdomain connection."
  type        = bool
  default     = true
}

variable health_check_enabled {
  description = "Enable and configure health checking for the service from the load balancer."
  type        = bool
  default     = true
}

variable health_check_path {
  description = "The path to check for health."
  type        = string
  default     = "/"
}

variable health_check_matcher {
  description = "The HTTP status code to match for a healthy response."
  type        = string
  default     = "200-499"
}

variable health_check_healthy_threshold {
  description = "The number of consecutive successful health checks required before considering an unhealthy target healthy."
  type        = number
  default     = 2
}

variable health_check_unhealthy_threshold {
  description = "The number of consecutive failed health checks required before considering a target unhealthy."
  type        = number
  default     = 2
}

variable health_check_interval {
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
  type        = number
  default     = 5
}

variable health_check_timeout {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  type        = number
  default     = 4
}

data "validation_error" "health_check_interval" {
  condition  = var.health_check_interval <= var.health_check_timeout
  summary = "health_check_interval must be greater than the health_check_timeout."
  details = <<EOF
For more details about configuring health checks on an AWS Load Balancer, see the AWS documentation:
https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-healthchecks.html
EOF
}

variable sticky_session_type {
  type        = string
  default     = "off"
  description = <<EOF
Enable sticky sessions by setting this to 'duration' or 'application'.
See more at  https://docs.aws.amazon.com/elasticloadbalancing/latest/application/sticky-sessions.html.

Available choices: 'off', 'duration', 'application'
By default, sticky sessions are 'off'.
EOF

  validation {
    condition     = contains(["off", "duration", "application"], var.sticky_session_type)
    error_message = "sticky_session_type must be 'off', 'duration', or 'application'"
  }
}

variable sticky_session_duration {
  type        = number
  default     = 86400
  description = <<EOF
When duration-based sticky sessions are enabled, this configures the expiration on a sticky session.
This value is represented in number of seconds with a range of 1 second to 1 week (604800 seconds).
The default value is 1 day (86400 seconds).

See more at https://docs.aws.amazon.com/elasticloadbalancing/latest/application/sticky-sessions.html#duration-based-stickiness.
EOF

  validation {
    condition     = var.sticky_session_duration >= 1 && var.sticky_session_duration <= 604800
    error_message = "sticky_session_duration must be at least 1 second and less than 604800 seconds (1 week)"
  }
}

variable sticky_session_cookie_name {
  type        = string
  default     = "STICKY_SESSION"
  description = <<EOF
When application-based sticky sessions are enabled, this configures the name of the cookie that tracks the sticky session.
This requires your application to set a cookie on a server request to track which requests should stick to that server.

See more at https://docs.aws.amazon.com/elasticloadbalancing/latest/application/sticky-sessions.html#application-based-stickiness.
EOF

  validation {
    condition     = !contains(["AWSALB", "AWSALBAPP", "AWSALBTG"], var.sticky_session_cookie_name)
    error_message = "The following cookie names are reserved for AWS and invalid: 'AWSALB', 'AWSALBAPP', 'AWSALBTG'."
  }
}
