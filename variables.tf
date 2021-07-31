variable "service_port" {
  description = "The load balancer will forward to this port on your service"
  type        = number
  default     = 80
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
  })
  default = {
    enabled = true
    path    = "/"
    matcher = "200-499"
  }
}
