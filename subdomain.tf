data "ns_connection" "subdomain" {
  name     = "subdomain"
  type     = "subdomain/aws"
  contract = "subdomain/aws/route53"
  optional = !var.enable_https
}

locals {
  subdomain_name            = trimsuffix(try(data.ns_connection.subdomain.outputs.fqdn, ""), ".")
  subdomain_zone_id         = try(data.ns_connection.subdomain.outputs.zone_id, "")
  subdomain_certificate_arn = try(data.ns_connection.subdomain.outputs.certificate_arn, "")
  subdomain_has_certificate = local.subdomain_certificate_arn != ""
}
