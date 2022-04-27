locals {
    execution_role = "AWS-SystemsManager-AutomationExecutionRole"
}

resource "aws_iam_role" "ssm_execution_role" {
    count = var.admin ? 0 : 1

    name = local.execution_role
    assume_role_policy = data.aws_iam_policy_document.ssm_assume_execution_role_policy[0].json
    path = "/"
}

resource "aws_iam_role_policy" "ssm_execution_role_policy" {
    count = var.admin ? 0 : 1

    name = local.execution_role
    role = aws_iam_role.ssm_execution_role[0].id
    policy = data.aws_iam_policy_document.ssm_execution_role_policy[0].json
}

data "aws_iam_policy_document" "ssm_execution_role_policy" {
    count = var.admin ? 0 : 1

    version = "2012-10-17"
    
    statement {
        effect = "Allow"
        actions = [
            "ec2:*",
            "eks:*",
            "ssm:*"
        ]
        resources = [
            "*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "iam:PassRole"
        ]
        resources = [
            aws_iam_role.ssm_execution_role[0].arn
        ]
    }
}

data "aws_iam_policy_document" "ssm_assume_execution_role_policy" {
    count = var.admin ? 0 : 1

    version = "2012-10-17"
    statement {
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::${var.admin_account_id}:root"
            ]
        }
        actions = [
            "sts:AssumeRole"
        ]
    }

    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "ssm.amazonaws.com"
            ]
        }
        actions = [
            "sts:AssumeRole"
        ]
    }
}