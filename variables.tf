variable "app_metadata" {
  description = <<EOF
App Metadata is injected from the app on-the-fly.
This contains information about resources created in the app module that are needed by the capability.
EOF

  type    = map(string)
  default = {}
}

variable "enable_https" {
  description = "Enable this to serve up HTTPS traffic. Requires subdomain connection."
  type        = bool
  default     = true
}

variable "health_check" {
  description = "Enable and configure health checking for the service from the load balancer."
  type = object({
    enabled : bool
    path : string
    matcher : string
    healthy_threshold : number
    interval : number
  })
  default = {
    enabled           = true
    path              = "/"
    matcher           = "200-499"
    healthy_threshold = 2
    interval          = 5
  }
}
