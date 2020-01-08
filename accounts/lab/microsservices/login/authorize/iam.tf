module "read_token_secret_policy" {
  source = "../../../../../modules/iam-inline-policy"

  name        = "cache-token-secret"
  common_tags = local.common_tags

  policy = {
    role = module.microsservice.iam_role_task_execution.name

    statements = [
      {
        sid       = "ReadToken"
        effect    = "Allow"
        resources = [module.cache.secret.arn]
        actions   = ["secretsmanager:GetSecretValue"]
      },
      {
        sid       = "DecryptToken"
        effect    = "Allow"
        resources = [module.cache.secret.kms_key_id]
        actions   = ["kms:Decrypt"]
      }
    ]
  }
}
