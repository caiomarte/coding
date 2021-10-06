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

data "aws_caller_identity" "AWSAccount" {}

data "aws_region" "AWSRegion" {}

data "aws_iam_policy_document" "BucketPolicy" {
    statement {
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::${local.ELBAccountId}:root"
            ]
        }
        actions = [
            "s3:PutObject"
        ]
        resources = [
            "${aws_s3_bucket.AccessLogs.arn}/*/AWSLogs/${data.aws_caller_identity.AWSAccount.account_id}/*"
        ]
    }

    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "delivery.logs.amazonaws.com"
            ]
        }
        actions = [
            "s3:PutObject"
        ]
        resources = [
            "${aws_s3_bucket.AccessLogs.arn}/*/AWSLogs/${data.aws_caller_identity.AWSAccount.account_id}/*"
        ]
        condition {
            test = "StringEquals"
            variable = "s3:x-amz-acl"
            values = [
                "bucket-owner-full-control"
            ]
        }
    }

    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "delivery.logs.amazonaws.com"
            ]
        }
        actions = [
            "s3:GetBucketAcl"
        ]
        resources = [
                aws_s3_bucket.AccessLogs.arn
        ]
    }
}

locals {
    ELBMap = {
        "us-east-1" = {
            ELBAccountId = "127311923021"
        },
        "us-east-2" = {
            ELBAccountId = "033677994240"
        },
        "us-west-1" = {
            ELBAccountId = "027434742980"
        },
        "us-west-2" = {
            ELBAccountId = "797873946194"
        },
        "ca-central-1" = {
            ELBAccountId = "985666609251"
        },
        "eu-central-1" = {
            ELBAccountId = "054676820928"
        },
        "eu-west-1" = {
            ELBAccountId = "156460612806"
        },
        "eu-west-2" = {
            ELBAccountId = "652711504416"
        },
        "eu-west-3" = {
            ELBAccountId = "009996457667"
        },
        "ap-northeast-1" = {
            ELBAccountId = "582318560864"
        },
        "ap-northeast-2" = {
            ELBAccountId = "600734575887"
        },
        "ap-northeast-3" = {
            ELBAccountId = "383597477331"
        },
        "ap-southeast-1" = {
            ELBAccountId = "114774131450"
        },
        "ap-southeast-2" = {
            ELBAccountId = "783225319266"
        },
        "ap-south-1" = {
            ELBAccountId = "718504428378"
        },
        "sa-east-1" = {
            ELBAccountId = "507241528517"
        }
        # Documentation reference: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
    }

    ELBAccountId = local.ELBMap[data.aws_region.AWSRegion.name]["ELBAccountId"]
}

resource "aws_s3_bucket" "AccessLogs" {
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_s3_bucket_ownership_controls" "AccessLogs" {
    bucket = aws_s3_bucket.AccessLogs.id
    
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "AccessLogs" {
    depends_on = [aws_s3_bucket_ownership_controls.AccessLogs]

    bucket = aws_s3_bucket.AccessLogs.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "BucketPolicy" {
    depends_on = [aws_s3_bucket_public_access_block.AccessLogs]
    
    bucket = aws_s3_bucket.AccessLogs.id
    policy = data.aws_iam_policy_document.BucketPolicy.json
}