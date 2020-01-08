locals {
  az_suffixes = { for az in var.availability_zones :
    az => replace(az, "/^[a-z]+-[a-z]+-[0-9]/", "")
  }

  prefixes = {
    public  = lookup(var.prefixes, "public", "pub")
    private = lookup(var.prefixes, "private", "prv")
  }

  public_prefix  = "${local.prefixes.public}-${var.name}"
  private_prefix = "${local.prefixes.private}-${var.name}"

  dns_mode    = lookup(var.dns, "mode", "route53")
  domain_name = lookup(var.dns, "domain_name", "${var.name}.cloud")

  common_tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
