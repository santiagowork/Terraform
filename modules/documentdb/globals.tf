locals {
  parameters = merge(
    lookup(var.parameter_group, "parameters", {}),
    {
      audit_logs = {
        value        = "enabled"
        apply_method = "immediate"
      }

      profiler = {
        value        = "enabled"
        apply_method = "immediate"
      }

      profiler_threshold_ms = {
        value        = 1000
        apply_method = "immediate"
      }

      ttl_monitor = {
        value = "enabled"
      }

      tls = {
        value = "enabled"
      }
    }
  )
}
