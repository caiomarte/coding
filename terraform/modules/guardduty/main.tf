terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = var.AWSRegion
}

resource "aws_guardduty_detector" "AcessoGovBrDetector" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}