locals {
    admin_role = "AWS-SystemsManager-AutomationAdministrationRole"
    execution_role_arns = [for i in var.managed_accounts_ids : "arn:aws:iam::${i}:role/AWS-SystemsManager-AutomationExecutionRole"]
}

resource "aws_iam_role" "ssm_management_role" {
    count = var.admin ? 1 : 0

    name = local.admin_role
    assume_role_policy = data.aws_iam_policy_document.ssm_assume_admin_role_policy[0].json
    path = "/"
}

resource "aws_iam_role_policy" "ssm_role_policy" {
    count = var.admin ? 1 : 0

    name = "AssumeRole-AWSSystemsManagerAutomationExecutionRole"
    role = aws_iam_role.ssm_management_role[0].id
    policy = data.aws_iam_policy_document.ssm_role_policy[0].json
}

data "aws_iam_policy_document" "ssm_role_policy" {
    count = var.admin ? 1 : 0
    
    version = "2012-10-17"

    statement {
        effect = "Allow"
        actions = [
            "sts:AssumeRole"
        ]
        resources = local.execution_role_arns
    }

    statement {
        effect = "Allow"
        actions = [
            "organizations:ListAccountsForParent"
        ]
        resources = [
            "*"
        ]
    }
}

data "aws_iam_policy_document" "ssm_assume_admin_role_policy" {
    count = var.admin ? 1 : 0
    
    version = "2012-10-17"
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