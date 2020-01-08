resource "aws_codebuild_project" "this" {
  name          = var.name
  description   = var.project.description
  build_timeout = lookup(var.project, "build_timeout", 60)
  service_role  = module.iam.iam_role.arn

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )

  environment {
    compute_type                = var.project.environment.compute_type
    image                       = var.project.environment.image
    type                        = lookup(var.project.environment, "type", "LINUX_CONTAINER")
    image_pull_credentials_type = lookup(var.project.environment, "image_pull_credentials_type", "CODEBUILD")
    privileged_mode             = lookup(var.project.environment, "privileged_mode", false)
    certificate                 = lookup(var.project.environment, "certificate", null)

    # registry_credential

    dynamic "environment_variable" {
      for_each = [for ev in lookup(var.project.environment, "environment_variables", []) : {
        name  = ev.name
        value = ev.value
        type  = lookup(ev, "type", "PLAINTEXT")
      }]

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  vpc_config {
    vpc_id  = var.vpc.id
    subnets = var.project.vpc_config.subnets

    security_group_ids = concat(
      [module.firewall.security_group.id],
      lookup(var.project.vpc_config, "extra_security_groups", [])
    )
  }

  source {
    type            = var.project.source.type
    location        = lookup(var.project.source, "location", null)
    git_clone_depth = lookup(var.project.source, "git_clone_depth", 1)
    buildspec       = lookup(var.project.source, "buildspec", null)
  }

  artifacts {
    type = var.project.artifact.type
  }

  # cache {
  #   type     = "S3"
  #   location = "${aws_s3_bucket.example.bucket}"
  # }
  #
  dynamic logs_config {
    for_each = [for lc in lookup(var.project, "logs_config", null) == null ? [] : [var.project.logs_config] : {
      cloudwatch_logs = lookup(lc, "cloudwatch_logs", [])
    }]

    content {
      dynamic cloudwatch_logs {
        for_each = [for cl in [logs_config.value.cloudwatch_logs] : {
          status      = lookup(cl, "status", "ENABLED")
          group_name  = lookup(cl, "group_name", "/codebuild/${var.name}")
          stream_name = lookup(cl, "stream_name", null)
        }]
        content {
          status      = cloudwatch_logs.value.status
          group_name  = cloudwatch_logs.value.group_name
          stream_name = cloudwatch_logs.value.stream_name
        }
      }
    }

    # s3_logs {
    #   status   = "ENABLED"
    #   location = "${aws_s3_bucket.example.id}/build-log"
    # }
  }
}
