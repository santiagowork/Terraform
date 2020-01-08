locals {
  launch_template = {
    credit_specification          = lookup(var.launch_template, "credit_specification", null)
    instance_market_options       = lookup(var.launch_template, "instance_market_options", null)
    block_device_mappings         = lookup(var.launch_template, "block_device_mappings", [])
    network_interfaces            = lookup(var.launch_template, "network_interfaces", [])
    elastic_gpu_specifications    = lookup(var.launch_template, "elastic_gpu_specifications", [])
    credit_specification          = lookup(var.launch_template, "credit_specification", null)
    elastic_inference_accelerator = lookup(var.launch_template, "elastic_inference_accelerator", [])
    license_specification         = lookup(var.launch_template, "license_specification", [])
    placement                     = lookup(var.launch_template, "placement", [])

    monitoring = lookup(var.launch_template, "monitoring", {
      enabled = true
    })
  }
}

resource "aws_launch_template" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name                                 = var.name
  description                          = var.launch_template.description
  image_id                             = var.launch_template.image_id
  instance_type                        = var.launch_template.instance_type
  ebs_optimized                        = lookup(var.launch_template, "ebs_optimized", true)
  user_data                            = lookup(var.launch_template, "user_data", null) != null ? base64encode(var.launch_template.user_data) : null
  disable_api_termination              = lookup(var.launch_template, "disable_api_termination", null)
  instance_initiated_shutdown_behavior = lookup(var.launch_template, "instance_initiated_shutdown_behavior", null)
  key_name                             = lookup(var.launch_template, "key_name", null)
  kernel_id                            = lookup(var.launch_template, "kernel_id", null)
  ram_disk_id                          = lookup(var.launch_template, "ram_disk_id", null)

  vpc_security_group_ids = length(local.launch_template.network_interfaces) > 0 ? [] : concat(
    [module.ec2_base.security_group.id],
    lookup(var.vpc, "extra_security_group_ids", [])
  )

  iam_instance_profile {
    arn = module.ec2_base.iam_instance_profile.arn
  }

  dynamic "monitoring" {
    for_each = [for m in local.launch_template.monitoring != null ? [local.launch_template.monitoring] : [] : {
      enabled = m.enabled
    }]
    content {
      enabled = monitoring.value.enabled
    }
  }

  dynamic "block_device_mappings" {
    for_each = [for bdm in local.launch_template.block_device_mappings : {
      device_name  = lookup(bdm, "device_name", null)
      no_device    = lookup(bdm, "no_device", null)
      virtual_name = lookup(bdm, "virtual_name", null)
      ebs          = lookup(bdm, "ebs", [])
    }]

    content {
      device_name  = block_device_mappings.value.device_name
      no_device    = block_device_mappings.value.no_device
      virtual_name = block_device_mappings.value.virtual_name

      dynamic "ebs" {
        for_each = [for e in [block_device_mappings.value.ebs] : {
          volume_type           = lookup(e, "volume_type", "gp2")
          volume_size           = lookup(e, "volume_size", null)
          delete_on_termination = lookup(e, "delete_on_termination", null)
          iops                  = lookup(e, "iops", null)
          encrypted             = lookup(e, "encrypted", null)
          kms_key_id            = lookup(e, "kms_key_id", null)
          snapshot_id           = lookup(e, "snapshot_id", null)
        }]

        content {
          volume_type           = ebs.value.volume_type
          volume_size           = ebs.value.volume_size
          delete_on_termination = ebs.value.delete_on_termination
          iops                  = ebs.value.iops
          encrypted             = ebs.value.encrypted
          kms_key_id            = ebs.value.kms_key_id
          snapshot_id           = ebs.value.snapshot_id
        }
      }
    }
  }

  dynamic "network_interfaces" {
    for_each = [for ni in local.launch_template.network_interfaces : {
      associate_public_ip_address = lookup(ni, "associate_public_ip_address", false)
      delete_on_termination       = lookup(ni, "delete_on_termination", true)
      description                 = lookup(ni, "description", "Managed by cloud-blueprints/aws-autoscaling-group module")
      device_index                = lookup(ni, "device_index", null)
      ipv6_addresses              = lookup(ni, "ipv6_addresses", null)
      ipv6_address_count          = lookup(ni, "ipv6_address_count", null)
      network_interface_id        = lookup(ni, "network_interface_id", null)
      private_ip_address          = lookup(ni, "private_ip_address", null)
      ipv4_address_count          = lookup(ni, "ipv4_address_count", null)
      ipv4_addresses              = lookup(ni, "ipv4_addresses", null)
      subnet_id                   = lookup(ni, "subnet_id", null)

      security_groups = concat(
        [module.ec2_base.security_group.id],
        lookup(var.vpc, "extra_security_group_ids", []),
        lookup(ni, "security_groups", [])
      )
    }]

    content {
      associate_public_ip_address = network_interfaces.value.associate_public_ip_address
      delete_on_termination       = network_interfaces.value.delete_on_termination
      description                 = network_interfaces.value.description
      device_index                = network_interfaces.value.device_index
      ipv6_addresses              = network_interfaces.value.ipv6_addresses
      ipv6_address_count          = network_interfaces.value.ipv6_address_count
      network_interface_id        = network_interfaces.value.network_interface_id
      private_ip_address          = network_interfaces.value.private_ip_address
      ipv4_address_count          = network_interfaces.value.ipv4_address_count
      ipv4_addresses              = network_interfaces.value.ipv4_addresses
      security_groups             = network_interfaces.value.security_groups
      subnet_id                   = network_interfaces.value.subnet_id
    }
  }

  dynamic "credit_specification" {
    for_each = [for cs in local.launch_template.credit_specification != null ? [local.launch_template.credit_specification] : [] : {
      cpu_credits = cs.cpu_credits
    }]

    content {
      cpu_credits = credit_specification.value.cpu_credits
    }
  }

  dynamic "instance_market_options" {
    for_each = [for imo in local.launch_template.instance_market_options != null ? [local.launch_template.instance_market_options] : [] : {
      market_type  = lookup(imo, "market_type", "spot")
      spot_options = imo.spot_options
    }]

    content {
      market_type = instance_market_options.value.market_type

      dynamic "spot_options" {
        for_each = [for so in [instance_market_options.value.spot_options] : {
          block_duration_minutes         = lookup(so, "block_duration_minutes", null)
          instance_interruption_behavior = lookup(so, "instance_interruption_behavior", "terminate")
          max_price                      = lookup(so, "max_price", null)
          spot_instance_type             = lookup(so, "spot_instance_type", null)
          valid_until                    = lookup(so, "valid_until", null)
        }]

        content {
          block_duration_minutes         = spot_options.value.block_duration_minutes
          instance_interruption_behavior = spot_options.value.instance_interruption_behavior
          max_price                      = spot_options.value.max_price
          spot_instance_type             = spot_options.value.spot_instance_type
          valid_until                    = spot_options.value.valid_until
        }
      }
    }
  }

  # capacity_reservation_specification = local.launch_template.capacity_reservation_specification
  # elastic_gpu_specifications           = local.launch_template.elastic_gpu_specifications
  # elastic_inference_accelerator        = local.launch_template.elastic_inference_accelerator
  # license_specification                = local.launch_template.license_specification
  # placement   = local.launch_template.placement

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      map("Name", "${var.name}-autoscaled"),
      var.common_tags
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.common_tags
  }

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
