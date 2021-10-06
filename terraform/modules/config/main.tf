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

data "aws_partition" "AWSPartition" {}

data "aws_iam_policy_document" "ConfigBucketPolicy" {
    version = "2012-10-17"
    statement {
        sid = "AWSConfigBucketPermissionsCheck"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "config.amazonaws.com"
            ]
        }
        actions = [
            "s3:GetBucketAcl"
        ]
        resources = [
            aws_s3_bucket.ConfigBucket.arn
        ]
    }

    statement {
        sid = "AWSConfigBucketDelivery"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "config.amazonaws.com"
            ]
        }
        actions = [
            "s3:PutObject"
        ]
        resources = [
            "${aws_s3_bucket.ConfigBucket.arn}/AWSLogs/${data.aws_caller_identity.AWSAccount.account_id}/*"
        ]
    }
}

data "aws_iam_policy_document" "ConfigTopicPolicy" {
    statement {
        sid = "AWSConfigSNSPolicy"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "config.amazonaws.com"
            ]
        }
        actions = [
            "sns:Publish"
        ]
        resources = [
            aws_sns_topic.ConfigTopic.*.arn[0]
        ]
    }
}

locals {
    FrequencyMap = {
        1 = "One_Hour"
        3 = "Three_Hours"
        6 = "Six_Hours"
        12 = "Twelve_Hours"
        24 = "TwentyFour_Hours"
    }
}

resource "aws_s3_bucket" "ConfigBucket" {
    bucket = "terraform-managed-config-bucket"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = var.KMSId
                sse_algorithm = "aws:kms"
            }
        }
    }
}

resource "aws_s3_bucket_policy" "ConfigBucketPolicy" {
    bucket = aws_s3_bucket.ConfigBucket.id
    policy = data.aws_iam_policy_document.ConfigBucketPolicy.json
}

resource "aws_sns_topic" "ConfigTopic" {
    count = var.TopicArn == "" ? 1 : 0

    name = "config-topic-${data.aws_caller_identity.AWSAccount.account_id}"
    display_name = "AWS Config Notification Topic"
    kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_policy" "ConfigTopicPolicy" {
    count = var.TopicArn == "" ? 1 : 0

    arn = aws_sns_topic.ConfigTopic.*.arn[0]
    policy = data.aws_iam_policy_document.ConfigTopicPolicy.json
}

resource "aws_sns_topic_subscription" "EmailNotification" {
    count = var.TopicArn == "" && var.NotificationEmail != "" ? 1 : 0

    endpoint = var.NotificationEmail
    protocol = "email"
    topic_arn = aws_sns_topic.ConfigTopic.*.arn[0]
}

resource "aws_iam_role" "ConfigRecorderRole" {
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = "sts:AssumeRole"
                Principal = {
                    Service = "config.amazonaws.com"
                }
            }
        ]
    })
    path = "/"
    managed_policy_arns = [
        "arn:${data.aws_partition.AWSPartition.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
    ]
}

resource "aws_config_configuration_recorder" "ConfigRecorder" {
    depends_on = [aws_s3_bucket_policy.ConfigBucketPolicy]

    role_arn = aws_iam_role.ConfigRecorderRole.arn
    recording_group {
        all_supported = var.AllSupported
        include_global_resource_types = var.IncludeGlobalResourceTypes
        resource_types = var.ResourceTypes
    }
}

resource "aws_config_delivery_channel" "ConfigDeliveryChannel" {
    depends_on = [aws_s3_bucket_policy.ConfigBucketPolicy, aws_config_configuration_recorder.ConfigRecorder]

    name = var.DeliveryChannelName != "" ? var.DeliveryChannelName : null
    snapshot_delivery_properties {
        delivery_frequency = local.FrequencyMap[var.Frequency]
    }
    s3_bucket_name = aws_s3_bucket.ConfigBucket.id
    sns_topic_arn = var.TopicArn != "" ? var.TopicArn : aws_sns_topic.ConfigTopic.*.arn[0]
}