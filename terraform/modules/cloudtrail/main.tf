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

data "aws_iam_policy_document" "TrailBucketPolicy" {
    version = "2012-10-17"
    statement {
        sid = "AWSTrailBucketPermissionsCheck"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "cloudtrail.amazonaws.com"
            ]
        }
        actions = [
            "s3:GetBucketAcl"
        ]
        resources = [
            aws_s3_bucket.TrailBucket.arn
        ]
    }
    
    statement {   
        sid = "AWSTrailBucketDelivery"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "cloudtrail.amazonaws.com"
            ]
        }
        actions = [
            "s3:PutObject"
        ]
        resources = [
            "${aws_s3_bucket.TrailBucket.arn}/AWSLogs/${data.aws_caller_identity.AWSAccount.account_id}/*"
        ]
    }
}

data "aws_iam_policy_document" "TrailTopicPolicy" {
    statement {
        sid = "AWSCloudTrailSNSPolicy"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "cloudtrail.amazonaws.com"
            ]
        }
        actions = [
            "sns:Publish"
        ]
        resources = [
            aws_sns_topic.TrailTopic.*.arn[0]
        ]
    }
}

locals {
    SNSTopicName = "tf-TrailTopic"
}

resource "aws_s3_bucket" "TrailBucket" {
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = var.KMSId
                sse_algorithm = "aws:kms"
            }
        }
    } 
}

resource "aws_s3_bucket_policy" "TrailBucketPolicy" {
    bucket = aws_s3_bucket.TrailBucket.id
    policy = data.aws_iam_policy_document.TrailBucketPolicy.json
}

resource "aws_sns_topic" "TrailTopic" {
    count = var.PublishToTopic ? 1 : 0

    name = local.SNSTopicName
    display_name = "AWS CloudTrail Notification Topic"
    kms_master_key_id = var.KMSId
}

resource "aws_sns_topic_policy" "TrailTopicPolicy" {
    count = var.PublishToTopic ? 1 : 0

    arn = aws_sns_topic.TrailTopic.*.arn[0]
    policy = data.aws_iam_policy_document.TrailTopicPolicy.json
}

resource "aws_sns_topic_subscription" "EmailNotification" {
    count = var.PublishToTopic && var.NotificationEmail != "" ? 1 : 0

    endpoint = var.NotificationEmail
    protocol = "email"
    topic_arn = aws_sns_topic.TrailTopic.*.arn[0]
}

resource "aws_cloudtrail" "Trail" {
    depends_on = [aws_s3_bucket_policy.TrailBucketPolicy, aws_sns_topic.TrailTopic]

    name = "tf-Trail"
    s3_bucket_name = aws_s3_bucket.TrailBucket.id
    sns_topic_name = var.PublishToTopic ? local.SNSTopicName : null
    enable_logging = true
    enable_log_file_validation = var.EnableLogFileValidation
    include_global_service_events = var.MultiRegion ? true : var.IncludeGlobalEvents
    is_multi_region_trail = var.MultiRegion
    kms_key_id = var.KMSId
}