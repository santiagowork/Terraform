variable "name" {
  type = string
}

variable "random_suffix_length" {
  type    = string
  default = 4
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "vpc" {
  type    = any
  default = {}
}

locals {
  vpc = {
    id                   = lookup(var.vpc, "id", null)
    private_route_tables = lookup(var.vpc, "private_route_tables", [])
  }
}

variable "security_group" {
  type    = any
  default = {}
}

locals {
  security_group = {
    allowed_traffic_to_internet_rules_count = lookup(var.security_group, "allowed_traffic_to_internet_rules_count", null)
    allowed_traffic_to_internet_rules = lookup(var.security_group, "allowed_traffic_to_internet_rules", [
      {
        description = "DNS"
        protocol    = "udp"
        from_port   = 53
        to_port     = 53
      },
      {
        description = "HTTPS"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
      },
      {
        description = "HTTP"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
      }
    ])
  }
}

variable "role" {
  type    = any
  default = {}
}

locals {
  role = {
    force_detach_policies = lookup(var.role, "force_detach_policies", true)
    path                  = lookup(var.role, "path", "/")
    description           = lookup(var.role, "description", "NAT instances IAM role")
    max_session_duration  = lookup(var.role, "max_session_duration", 3600)
    permissions_boundary  = lookup(var.role, "permissions_boundary", null)
    policy_arns           = lookup(var.role, "policy_arns", [])
    inline_policies       = lookup(var.role, "inline_policies", {})
  }
}

variable "logs_kms_key" {
  type    = any
  default = {}
}

locals {
  logs_kms_key = {
    arn                     = lookup(var.logs_kms_key, "arn", null)
    aws_account_id          = lookup(var.logs_kms_key, "aws_account_id", null)
    deletion_window_in_days = lookup(var.logs_kms_key, "deletion_window_in_days", 30)
  }
}

variable "logs_kms_alias" {
  type    = any
  default = {}
}

locals {
  logs_kms_alias = {
    prefix     = lookup(var.logs_kms_alias, "prefix", null)
    use_region = lookup(var.logs_kms_alias, "use_region", true)
    aws_region = lookup(var.logs_kms_alias, "aws_region", null)
  }
}

variable "launch_template" {
  type    = any
  default = {}
}

locals {
  launch_template = {
    description                          = "${var.name} instances template"
    image_id                             = data.aws_ami.this.image_id
    instance_type                        = lookup(var.launch_template, "instance_type", "t3.nano")
    ebs_optimized                        = lookup(var.launch_template, "ebs_optimized", true)
    user_data                            = lookup(var.launch_template, "user_data", null)
    disable_api_termination              = lookup(var.launch_template, "disable_api_termination", null)
    instance_initiated_shutdown_behavior = lookup(var.launch_template, "instance_initiated_shutdown_behavior", null)
    key_name                             = lookup(var.launch_template, "key_name", null)
    kernel_id                            = lookup(var.launch_template, "kernel_id", null)
    ram_disk_id                          = lookup(var.launch_template, "ram_disk_id", null)
    instance_market_options              = lookup(var.launch_template, "instance_market_options", null)
    block_device_mappings                = lookup(var.launch_template, "block_device_mappings", [])
    elastic_gpu_specifications           = lookup(var.launch_template, "elastic_gpu_specifications", [])
    capacity_reservation_specification   = lookup(var.launch_template, "capacity_reservation_specification", [])
    elastic_inference_accelerator        = lookup(var.launch_template, "elastic_inference_accelerator", [])
    license_specification                = lookup(var.launch_template, "license_specification", [])
    placement                            = lookup(var.launch_template, "placement", [])

    credit_specification = lookup(var.launch_template, "credit_specification", {
      cpu_credits = "standard"
    })

    network_interfaces = lookup(var.launch_template, "network_interfaces", [{
      associate_public_ip_address = true
      description                 = "Main ${var.name} instance network interface"
    }])

    monitoring = lookup(var.launch_template, "monitoring", {
      enabled = true
    })
  }
}

variable "ami" {
  type    = any
  default = {}
}

locals {
  ami = {
    most_recent = lookup(var.ami, "most_recent", true)
    owner       = lookup(var.ami, "owner", "self")
    name        = lookup(var.ami, "name", null)
  }
}

variable "autoscaling_group" {
  type    = any
  default = {}
}

locals {
  autoscaling_group = {
    min_size                  = 1
    max_size                  = 1
    vpc_zone_identifier       = lookup(var.autoscaling_group, "vpc_zone_identifier", null)
    force_delete              = true
    protect_from_scale_in     = false
    default_cooldown          = 60
    health_check_grace_period = 120
    health_check_type         = "EC2"
    suspended_processes       = lookup(var.autoscaling_group, "suspended_processes", [])
    placement_group           = lookup(var.autoscaling_group, "placement_group", null)
    service_linked_role_arn   = lookup(var.autoscaling_group, "service_linked_role_arn", null)
    mixed_instances_policy    = lookup(var.autoscaling_group, "mixed_instances_policy", null)
    initial_lifecycle_hook    = lookup(var.autoscaling_group, "initial_lifecycle_hook", null)
    ebs_kms_key_ids           = lookup(var.autoscaling_group, "ebs_kms_key_ids", [])
    wait_for_capacity_timeout = 0

    termination_policies = [
      "OldestLaunchTemplate",
      "OldestInstance",
      "Default"
    ]

    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupPendingInstances",
      "GroupStandbyInstances",
      "GroupTerminatingInstances",
      "GroupTotalInstances"
    ]
  }
}
