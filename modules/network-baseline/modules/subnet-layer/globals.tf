locals {
  az_suffixes = { for az in var.availability_zones :
    az => replace(az, "/^[a-z]+-[a-z]+-[0-9]/", "")
  }

  first_network    = lookup(var.networks, "first_network", 0)
  addresses_number = lookup(var.networks, "addresses_number", 32)
  public           = lookup(var.networks, "public", false)
  newbits          = (32 - log(local.addresses_number, 10) / log(2, 10)) - replace(var.vpc.cidr_block, "/^[0-9]{1,3}(\\.[0-9]+){3}\\//", "")

  cidr_blocks = { for az in var.availability_zones :
    az => cidrsubnet(var.vpc.cidr_block, local.newbits, local.first_network + index(tolist(var.availability_zones), az))
  }
}
