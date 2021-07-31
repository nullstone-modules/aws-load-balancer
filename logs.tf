module "logs_bucket" {
  source        = "./logs_bucket"
  name          = local.resource_name
  tags          = data.ns_workspace.this.tags
  force_destroy = true

  count = var.enable_access_logs ? 1 : 0
}
