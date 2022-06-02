module "logs_bucket" {
  source        = "./logs_bucket"
  name          = local.resource_name
  tags          = local.tags
  force_destroy = true
}
