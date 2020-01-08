resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = module.role.iam_role.arn

  dynamic "recording_group" {
    for_each = [for rg in [lookup(var.config, "recording_group", {
      all_supported                 = true
      include_global_resource_types = true
      })] : {
      all_supported                 = lookup(rg, "all_supported", false)
      include_global_resource_types = lookup(rg, "include_global_resource_types", true)
      resource_types                = lookup(rg, "resource_types", null)
    }]

    content {
      all_supported                 = recording_group.value.all_supported
      include_global_resource_types = recording_group.value.include_global_resource_types
      resource_types                = recording_group.value.resource_types
    }
  }
}

resource "aws_config_delivery_channel" "this" {
  depends_on = [aws_config_configuration_recorder.this]

  name           = var.name
  s3_bucket_name = var.config.bucket
  s3_key_prefix  = lookup(var.config, "s3_key_prefix", null)
  sns_topic_arn  = lookup(var.config, "sns_topic_arn", null)

  dynamic "snapshot_delivery_properties" {
    for_each = [for sdp in [lookup(var.config, "snapshot_delivery_properties", {
      delivery_frequency = "One_Hour"
      })] : {
      delivery_frequency = sdp.delivery_frequency
    }]

    content {
      delivery_frequency = snapshot_delivery_properties.value.delivery_frequency
    }
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  depends_on = [aws_config_delivery_channel.this]

  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
}
