terraform {
  required_version = ">= 0.12.0"

  backend "s3" {
    bucket     = "tfstate-197298744561"
    key        = "lab/microsservices/login-authorization-code-exchange.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:us-east-1:197298744561:key/a47deeac-c66c-4a71-b9e6-95da353b89f7"
  }
}

provider "aws" {
  alias               = "lab"
  version             = "~> 2.0"
  region              = "us-east-1"
  allowed_account_ids = ["197298744561"]
}

provider "random" {
  version = "~> 2.1"
}
