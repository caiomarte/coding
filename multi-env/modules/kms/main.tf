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

data "aws_iam_policy_document" "KeyPolicy" {
    statement {
        sid = "Enable IAM policies"
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::${data.aws_caller_identity.AWSAccount.account_id}:root"
            ]
        }
        actions = [
            "kms:*"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid = "Allow access for Key Administrators"
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                var.AdminRoleArn
            ]
        }
        actions = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid = "Allow use of the key"
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::${data.aws_caller_identity.AWSAccount.account_id}:root",
                var.AdminRoleArn
            ]
        }
        actions = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        sid = "Allow attachment of persistent resources"
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::${data.aws_caller_identity.AWSAccount.account_id}:root",
                var.AdminRoleArn
            ]
        }
        actions = [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
        ]
        resources = [
            "*"
        ]
        condition {
            test = "Bool"
            variable = "kms:GrantIsForAWSResource"
            values = [
                true
            ]
        }
    }

    statement {
        sid = "Allow CloudWatch Logs"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "logs.${data.aws_region.AWSRegion.name}.amazonaws.com"
            ]
        }
        actions = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
        ]
        resources = [
            "*"
        ]
        condition {
            test = "ArnLike"
            variable = "kms:EncryptionContext:aws:logs:arn"
            values = [
                "arn:aws:logs:${data.aws_region.AWSRegion.name}:${data.aws_caller_identity.AWSAccount.account_id}:*"
            ]
        }
    }

    statement {
        sid = "Allow AWS Services supported by ViaService"
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                var.AdminRoleArn
            ]
        }
        actions = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
        ]
        resources = [
            "*"
        ]
        condition {
            test = "StringEquals"
            variable = "kms:ViaService"
            values = [
                "rds.${data.aws_region.AWSRegion.name}.amazonaws.com",                  # Amazon Aurora
                "backup.${data.aws_region.AWSRegion.name}.amazonaws.com",               # AWS Backup
                "dms.${data.aws_region.AWSRegion.name}.amazonaws.com",                  # AWS Database Migration Service (AWS DMS)
                "ssm.${data.aws_region.AWSRegion.name}.amazonaws.com",                  # Amazon EC2 Systems Manager (SSM)
                "ec2.${data.aws_region.AWSRegion.name}.amazonaws.com",                  # Amazon Elastic Block Store (Amazon EBS)
                "ecr.${data.aws_region.AWSRegion.name}.amazonaws.com",                  # Amazon Elastic Container Registry (Amazon ECR)
                "elasticfilesystem.${data.aws_region.AWSRegion.name}.amazonaws.com",    # Amazon Elastic File System (Amazon EFS)
                "elasticache.${data.aws_region.AWSRegion.name}.amazonaws.com",          # Amazon ElastiCache
                "dax.${data.aws_region.AWSRegion.name}.amazonaws.com",                  # Amazon DynamoDB Accelerator (DAX)
                "es.${data.aws_region.AWSRegion.name}.amazonaws.com",                   # Amazon Elasticsearch Service (Amazon ES)
                "lambda.${data.aws_region.AWSRegion.name}.amazonaws.com",               # AWS Lambda
                "kafka.${data.aws_region.AWSRegion.name}.amazonaws.com",                # Amazon Managed Streaming for Apache Kafka (Amazon MSK)
                "secretsmanager.${data.aws_region.AWSRegion.name}.amazonaws.com",       # AWS Secrets Manager
                "s3.${data.aws_region.AWSRegion.name}.amazonaws.com"                    # Amazon Simple Storage Service (Amazon S3)
                # Not all services support kms:ViaService
                # Reference: https://docs.aws.amazon.com/kms/latest/developerguide/policy-conditions.html#conditions-kms-via-service
            ]
        }
    }
}

resource "aws_kms_key" "Key" {
    enable_key_rotation = true
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    key_usage = "ENCRYPT_DECRYPT"
    policy = data.aws_iam_policy_document.KeyPolicy.json
}

resource "aws_kms_alias" "KeyAlias" {
    name = "alias/${var.AliasName}"
    target_key_id = aws_kms_key.Key.id
}