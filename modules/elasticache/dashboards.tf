# data "template_file" "dashboard" {
#   template = "${file("${path.module}/data/dashboard.json")}"
#
#   vars {
#     cluster_id = "${aws_elasticache_replication_group.this.id}-001"
#   }
# }
#
# resource "aws_cloudwatch_dashboard" "this" {
#   dashboard_name = "${var.name}"
#   dashboard_body = "${data.template_file.dashboard.rendered}"
# }
