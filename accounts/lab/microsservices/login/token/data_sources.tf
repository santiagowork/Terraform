data "aws_region" "this" {
  provider = aws.lab
}

data "aws_caller_identity" "this" {
  provider = aws.lab
}

data "aws_vpc" "rdeai_lab" {
  provider = aws.lab

  tags = {
    Name = "${local.business_unit}-${local.environment}"
  }
}

data "aws_subnet_ids" "app" {
  provider = aws.lab
  vpc_id   = data.aws_vpc.rdeai_lab.id

  filter {
    name = "tag:Name"
    values = [
      "prv-app-rdeai-lab-a",
      "prv-app-rdeai-lab-b",
      "prv-app-rdeai-lab-c",
    ]
  }
}

data "aws_subnet_ids" "data" {
  provider = aws.lab
  vpc_id   = data.aws_vpc.rdeai_lab.id

  filter {
    name = "tag:Name"
    values = [
      "prv-data-rdeai-lab-a",
      "prv-data-rdeai-lab-b",
      "prv-data-rdeai-lab-c",
    ]
  }
}

data "aws_kms_key" "logging" {
  provider = aws.lab
  key_id   = "alias/lab/us-east-1/log/rdeai"
}

data "aws_ecs_cluster" "this" {
  provider     = aws.lab
  cluster_name = "rdeai"
}

data "external" "namespace" {
  program = [
    "bash",
    "-c",
    "aws servicediscovery list-namespaces --query 'Namespaces[?Name==`rdeai-lab.cloud`]|[0].{id:Id}'"
  ]
}

data "aws_security_group" "public_lb" {
  filter {
    name   = "tag:Name"
    values = ["alb-rdeai-apps-lab"]
  }
}

data "aws_security_group" "endpoint_access" {
  filter {
    name   = "tag:Name"
    values = ["vpc-endpoints-access-rdeai-lab"]
  }
}

data "aws_lb" "public" {
  name = "rdeai-apps-lab"
}

data "aws_lb_listener" "public_https" {
  load_balancer_arn = data.aws_lb.public.arn
  port              = 443
}

data "aws_security_group" "autorization_code_exchange" {
  filter {
    name   = "tag:Name"
    values = ["ecs-eai_login_autorization-code-exchange"]
  }
}

data "aws_kms_key" "parameters" {
  provider = aws.lab
  key_id   = "alias/lab/us-east-1/parameters/rdeai"
}

data "aws_secretsmanager_secret" "tracer_token" {
  provider = aws.lab
  name     = "lab/microsservices/tracer-token"
}

data "aws_ssm_parameter" "tracer_host" {
  name = "/lab/microsservices/tracer-host"
}

data "aws_ssm_parameter" "tracer_port" {
  name = "/lab/microsservices/tracer-port"
}
