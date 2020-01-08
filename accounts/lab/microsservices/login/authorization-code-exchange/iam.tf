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
        sid       = "ReadAuthCodeExchangeToken" 
        effect    = "Allow" 
        resources = [module.token_secret.secret.arn] 
        actions   = ["secretsmanager:GetSecretValue"] 
      }, 
      { 
        sid       = "DecryptAuthCodeExchangeToken" 
        effect    = "Allow" 
        resources = [module.token_secret.secret.kms_key_id] 
        actions   = ["kms:Decrypt"] 
      }, 
      { 
        sid       = "ReadAuthCodeExchangeSecret" 
        effect    = "Allow" 
        resources = [module.secret_secret.secret.arn] 
        actions   = ["secretsmanager:GetSecretValue"] 
      }, 
      { 
        sid       = "DecryptAuthCodeExchangeSecret" 
        effect    = "Allow" 
        resources = [module.secret_secret.secret.kms_key_id] 
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
          data.aws_ssm_parameter.authorize_host.arn,
          data.aws_ssm_parameter.authorize_port.arn,
          data.aws_ssm_parameter.token_host.arn,
          data.aws_ssm_parameter.token_port.arn,
        ] 
      }, 
    ] 
  } 
} 
 
