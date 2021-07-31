variable "enable_https" {
  description = "Enable this to serve up HTTPS traffic. Requires subdomain connection."
  type        = bool
  default     = true
}

variable "enable_access_logs" {
  description = "Enable this to log all traffic to an s3 bucket"
  type        = bool
  default     = false
}

variable "health_check" {
  description = "Configuration for health checking the target group attached to the load balancer"
  type = object({
    enabled : bool
    path : string
    matcher : string
  })
  default = {
    enabled = true
    path    = "/"
    matcher = "200-499"
  }
}
