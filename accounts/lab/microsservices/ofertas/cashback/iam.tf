module "read_parameters_policy" {
  source = "../../../../../modules/iam-inline-policy"

  name        = "read-parameters"
  common_tags = local.common_tags

  policy = {
    role = module.microsservice.iam_role_task_execution.name

    statements = [
      {
        sid       = "ReadAPMToken"
        effect    = "Allow"
        resources = [data.aws_secretsmanager_secret.tracer_token.arn]
        actions   = ["secretsmanager:GetSecretValue"]
      },
      {
        sid       = "DecryptAPMToken"
        effect    = "Allow"
        resources = [data.aws_secretsmanager_secret.tracer_token.kms_key_id]
        actions   = ["kms:Decrypt"]
      },
      {
        sid       = "ReadTokenToken"
        effect    = "Allow"
        resources = [module.token_secret.secret.arn]
        actions   = ["secretsmanager:GetSecretValue"]
      },
      {
        sid       = "DecryptTokenToken"
        effect    = "Allow"
        resources = [module.token_secret.secret.kms_key_id]
        actions   = ["kms:Decrypt"]
      },
      {
        sid       = "ReadSecretToken"
        effect    = "Allow"
        resources = [module.secret_secret.secret.arn]
        actions   = ["secretsmanager:GetSecretValue"]
      },
      {
        sid       = "DecryptSecretToken"
        effect    = "Allow"
        resources = [module.secret_secret.secret.kms_key_id]
        actions   = ["kms:Decrypt"]
      },
      {
        sid       = "ReadMongoDBURL"
        effect    = "Allow"
        resources = [module.mongodb_secret.secret.arn]
        actions   = ["secretsmanager:GetSecretValue"]
      },
      {
        sid       = "DecryptMongoDBURL"
        effect    = "Allow"
        resources = [module.mongodb_secret.secret.kms_key_id]
        actions   = ["kms:Decrypt"]
      },
      {
        sid       = "DecryptParameters"
        effect    = "Allow"
        resources = [data.aws_kms_key.parameters.arn]
        actions   = ["kms:Decrypt"]
      },
      {
        sid    = "ReadParameters"
        effect = "Allow"

        actions = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]

        resources = [
          data.aws_ssm_parameter.tracer_host.arn,
          data.aws_ssm_parameter.tracer_port.arn,
          module.with_tracer_parameter.parameter_store.arn,
          module.flask_support_parameter.parameter_store.arn,
          module.realm_parameter.parameter_store.arn,
          module.exp_authorization_code_parameter.parameter_store.arn,
          module.exp_refresh_token_parameter.parameter_store.arn,
          module.service_name_parameter.parameter_store.arn,
          module.authorization_code_path_parameter.parameter_store.arn,
          module.grant_type_path_parameter.parameter_store.arn,
          module.refresh_token_path_parameter.parameter_store.arn,
          module.grant_type_path_parameter.parameter_store.arn,
        ]
      },
    ]
  }
}
