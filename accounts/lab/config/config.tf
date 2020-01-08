module "config" {
  source = "../../../modules/config"

  name        = "rdeailab"
  common_tags = local.common_tags

  config = {
    bucket = module.bucket.bucket.id
  }
}
