locals {
  default_pgsql_parameters = [
    {
      name  = "log_autovacuum_min_duration"
      value = 1000
    },
    {
      name  = "log_checkpoints"
      value = 1
    },
    {
      name  = "log_connections"
      value = 1
    },
    {
      name  = "log_disconnections"
      value = 1
    },
    {
      name  = "log_lock_waits"
      value = 1
    },
    {
      name  = "log_min_duration_statement"
      value = 1000
    },
    {
      name  = "log_statement"
      value = "ddl"
    },
    {
      name  = "pgaudit.log"
      value = "all,-read,-write"
    },
    {
      name  = "pgaudit.log_parameter"
      value = 0
    },
    {
      name  = "ssl"
      value = 1
    },
    {
      name  = "rds.force_ssl"
      value = 1
    },
  ]
}
