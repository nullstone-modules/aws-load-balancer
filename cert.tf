module "cert" {
  source  = "nullstone-modules/sslcert/aws"
  version = "~> 0.3.0"
  enabled = var.enable_https && !local.subdomain_has_certificate

  domain = {
    name    = local.subdomain_name
    zone_id = local.subdomain_zone_id
  }

  tags = local.tags
}

locals {
  certificate_arn = local.subdomain_has_certificate ? local.subdomain_certificate_arn : module.cert.certificate_arn
}
