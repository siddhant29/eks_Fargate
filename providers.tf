terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = "AKIA6FSGW5JHPM7BZOGO"
  secret_key = "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"
}