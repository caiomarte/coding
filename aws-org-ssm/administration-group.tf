resource "aws_iam_group" "ssm_admin_group" {
    count = var.admin ? 1 : 0
    
    name = "ssm-group-admin"
    path = "/"
}

resource "aws_iam_group_membership" "ssm_admin_group_members" {
    count = var.admin ? 1 : 0

    name = "ssm-group-membership-admin"
    users = var.ssm_admins
    group = aws_iam_group.ssm_admin_group[0].name
}

resource "aws_iam_group_policy_attachment" "ssm_admin_group_policy" {
    count = var.admin ? 1 : 0

    group = aws_iam_group.ssm_admin_group[0].name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

resource "aws_iam_group_policy" "ssm_admin_group_policy" {
    count = var.admin ? 1 : 0
    
    name = "ssm-policy-admin-cross-account"
    group = aws_iam_group.ssm_admin_group[0].name
    policy = data.aws_iam_policy_document.ssm_admin_group_policy_document[0].json
}

data "aws_iam_policy_document" "ssm_admin_group_policy_document" {
    count = var.admin ? 1 : 0
    
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
            "arn:aws:iam::${var.admin_account_id}:role/${local.admin_role}"
        ]
    }
}