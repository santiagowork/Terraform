resource "random_id" "this" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
  }
}

resource "aws_api_gateway_api_key" "this" {
  name        = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  description = var.api.api_key_description
  enabled     = true
}
