locals {
  common_tags = merge(
    map("NatInstanceInfrastructure", true),
    var.common_tags
  )
}
