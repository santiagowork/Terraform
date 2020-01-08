resource "aws_service_discovery_service" "this" {
  name        = var.name
  description = lookup(var.service, "service_discovery_description", "Discover ${var.name} container tasks")

  dns_config {
    namespace_id   = var.service.namespace_id
    routing_policy = "MULTIVALUE"

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}
