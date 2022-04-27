terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = local.AWSRegion
}

locals {
    # For CLOUDFRONT, you must create your WAFv2 resources in the US East (N. Virginia) Region, us-east-1.
    AWSRegion = var.Scope == "CLOUDFRONT" ? "us-east-1" : var.AWSRegion

    ## Custom WAF Rules
    BlockIPv4 = var.BlockIPv4 == "Yes" ? [{
        name = "BlockIPv4"
        priority = 0
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "IPlistRuleIPv4Metric"
        arn = aws_wafv2_ip_set.BlockListIPv4.*.arn[0]
    }] : []

    RateLimitBlock = var.RateLimitAction == "Block" ? [{
        name = "RateLimit"
        priority = 1
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "RateLimit"
        limit = var.RateLimit
        aggregate_key_type = "IP"
    }] : []

    RateLimitCount = var.RateLimitAction == "Count" ? [{
        name = "RateLimit"
        priority = 1
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "RateLimit"
        limit = var.RateLimit
        aggregate_key_type = "IP"
    }] : []

    IPSetReferenceStatementRules = concat(local.BlockIPv4, [])
    RateBasedStatementBlockRules = concat(local.RateLimitBlock, [])
    RateBasedStatementCountRules = concat(local.RateLimitCount, [])

    ##  AWS Managed WAF Rules
    AWSManagedRulesCommonRuleSetBlock = var.AWSManagedRulesCommonRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesCommonRuleSet"
        priority = 10
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesCommonRuleSet"
    }] : []

     AWSManagedRulesCommonRuleSetCount = var.AWSManagedRulesCommonRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesCommonRuleSet"
        priority = 10
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesCommonRuleSet"
    }] : []

    AWSManagedRulesAdminProtectionRuleSetBlock = var.AWSManagedRulesAdminProtectionRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesAdminProtectionRuleSet"
        priority = 11
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesAdminProtectionRuleSet"
    }] : []

    AWSManagedRulesAdminProtectionRuleSetCount = var.AWSManagedRulesAdminProtectionRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesAdminProtectionRuleSet"
        priority = 11
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesAdminProtectionRuleSet"
    }] : []

    AWSManagedRulesKnownBadInputsRuleSetBlock = var.AWSManagedRulesKnownBadInputsRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesKnownBadInputsRuleSet"
        priority = 12
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesKnownBadInputsRuleSet"
    }] : []

    AWSManagedRulesKnownBadInputsRuleSetCount = var.AWSManagedRulesKnownBadInputsRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesKnownBadInputsRuleSet"
        priority = 12
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesKnownBadInputsRuleSet"
    }] : []

    AWSManagedRulesSQLiRuleSetBlock = var.AWSManagedRulesSQLiRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesSQLiRuleSet"
        priority = 13
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesSQLiRuleSet"
    }] : []

    AWSManagedRulesSQLiRuleSetCount = var.AWSManagedRulesSQLiRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesSQLiRuleSet"
        priority = 13
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesSQLiRuleSet"
    }] : []

    AWSManagedRulesLinuxRuleSetBlock = var.AWSManagedRulesLinuxRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesLinuxRuleSet"
        priority = 14
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesLinuxRuleSet"
    }] : []

    AWSManagedRulesLinuxRuleSetCount = var.AWSManagedRulesLinuxRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesLinuxRuleSet"
        priority = 14
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesLinuxRuleSet"
    }] : []

    AWSManagedRulesUnixRuleSetBlock = var.AWSManagedRulesUnixRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesUnixRuleSet"
        priority = 15
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesUnixRuleSet"
    }] : []

    AWSManagedRulesUnixRuleSetCount = var.AWSManagedRulesUnixRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesUnixRuleSet"
        priority = 15
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesUnixRuleSet"
    }] : []

    AWSManagedRulesPHPRuleSetBlock = var.AWSManagedRulesPHPRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesPHPRuleSet"
        priority = 16
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesPHPRuleSet"
    }] : []

    AWSManagedRulesPHPRuleSetCount = var.AWSManagedRulesPHPRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesPHPRuleSet"
        priority = 16
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesPHPRuleSet"
    }] : []

    AWSManagedRulesAmazonIpReputationListBlock = var.AWSManagedRulesAmazonIpReputationListAction == "Block" ? [{
        name = "AWSManagedRulesAmazonIpReputationList"
        priority = 17
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesAmazonIpReputationList"
    }] : []

    AWSManagedRulesAmazonIpReputationListCount = var.AWSManagedRulesAmazonIpReputationListAction == "Count" ? [{
        name = "AWSManagedRulesAmazonIpReputationList"
        priority = 17
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesAmazonIpReputationList"
    }] : []

    AWSManagedRulesAnonymousIpListBlock = var.AWSManagedRulesAnonymousIpListAction == "Block" ? [{
        name = "AWSManagedRulesAnonymousIpList"
        priority = 18
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesAnonymousIpList"
    }] : []

    AWSManagedRulesAnonymousIpListCount = var.AWSManagedRulesAnonymousIpListAction == "Count" ? [{
        name = "AWSManagedRulesAnonymousIpList"
        priority = 18
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesAnonymousIpList"
    }] : []

    AWSManagedRulesBotControlRuleSetBlock = var.AWSManagedRulesBotControlRuleSetAction == "Block" ? [{
        name = "AWSManagedRulesBotControlRuleSet"
        priority = 19
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesBotControlRuleSet"
    }] : []

    AWSManagedRulesBotControlRuleSetCount = var.AWSManagedRulesBotControlRuleSetAction == "Count" ? [{
        name = "AWSManagedRulesBotControlRuleSet"
        priority = 19
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        group_name = "AWSManagedRulesBotControlRuleSet"
    }] : []

    ManagedRuleGroupStatementBlockRules = concat(
        local.AWSManagedRulesCommonRuleSetBlock,
        local.AWSManagedRulesAdminProtectionRuleSetBlock,
        local.AWSManagedRulesKnownBadInputsRuleSetBlock,
        local.AWSManagedRulesSQLiRuleSetBlock,
        local.AWSManagedRulesLinuxRuleSetBlock,
        local.AWSManagedRulesUnixRuleSetBlock,
        local.AWSManagedRulesPHPRuleSetBlock,
        local.AWSManagedRulesAmazonIpReputationListBlock,
        local.AWSManagedRulesAnonymousIpListBlock,
        local.AWSManagedRulesBotControlRuleSetBlock
    )
    ManagedRuleGroupStatementCountRules = concat(
        local.AWSManagedRulesCommonRuleSetCount,
        local.AWSManagedRulesAdminProtectionRuleSetCount,
        local.AWSManagedRulesKnownBadInputsRuleSetCount,
        local.AWSManagedRulesSQLiRuleSetCount,
        local.AWSManagedRulesLinuxRuleSetCount,
        local.AWSManagedRulesUnixRuleSetCount,
        local.AWSManagedRulesPHPRuleSetCount,
        local.AWSManagedRulesAmazonIpReputationListCount,
        local.AWSManagedRulesAnonymousIpListCount,
        local.AWSManagedRulesBotControlRuleSetCount
    )
}

resource "aws_wafv2_ip_set" "BlockListIPv4" {
    count = var.BlockIPv4 == "Yes" ? 1 : 0

    description = "Terraform-managed."
    scope = var.Scope
    ip_address_version = "IPV4"
    addresses = var.BlockIPv4Addresses

    name = "BlockListIPv4"
}

resource "aws_wafv2_web_acl" "WebACL" {
    depends_on = [aws_wafv2_ip_set.BlockListIPv4]

    name = "WebACL"
    description = "Terraform-managed."
    scope = var.Scope

    default_action {
        allow {}
    }

    visibility_config {
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = var.MetricName
    }

    dynamic "rule" {
        for_each = toset(local.IPSetReferenceStatementRules)

        content {
            name = rule.value.name
            priority = rule.value.priority
            action {
                block {}
            }
            visibility_config {
                sampled_requests_enabled = rule.value.sampled_requests_enabled
                cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
                metric_name = rule.value.metric_name
            }
            statement {
                ip_set_reference_statement {
                    arn = rule.value.arn
                }
            }
        }
    }

    dynamic "rule" {
        for_each = toset(local.RateBasedStatementBlockRules)

        content {
            name = rule.value.name
            priority = rule.value.priority
            action {
                block {}
            }
            visibility_config {
                sampled_requests_enabled = rule.value.sampled_requests_enabled
                cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
                metric_name = rule.value.metric_name
            }
            statement {
                rate_based_statement {
                    limit = rule.value.limit
                    aggregate_key_type = rule.value.aggregate_key_type
                }
            }
        }
    }

    dynamic "rule" {
        for_each = toset(local.RateBasedStatementCountRules)

        content {
            name = rule.value.name
            priority = rule.value.priority
            action {
                count {}
            }
            visibility_config {
                sampled_requests_enabled = rule.value.sampled_requests_enabled
                cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
                metric_name = rule.value.metric_name
            }
            statement {
                rate_based_statement {
                    limit = rule.value.limit
                    aggregate_key_type = rule.value.aggregate_key_type
                }
            }
        }
    }

    dynamic "rule" {
        for_each = toset(local.ManagedRuleGroupStatementBlockRules)

        content {
            name = rule.value.name
            priority = rule.value.priority
            override_action {
                none {}
            }
            visibility_config {
                sampled_requests_enabled = rule.value.sampled_requests_enabled
                cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
                metric_name = rule.value.metric_name
            }
            statement {
                managed_rule_group_statement {
                    vendor_name = rule.value.vendor_name
                    name = rule.value.group_name
                }
            }
        }
    }

    dynamic "rule" {
        for_each = toset(local.ManagedRuleGroupStatementCountRules)

        content {
            name = rule.value.name
            priority = rule.value.priority
            override_action {
                count {}
            }
            visibility_config {
                sampled_requests_enabled = rule.value.sampled_requests_enabled
                cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
                metric_name = rule.value.metric_name
            }
            statement {
                managed_rule_group_statement {
                    vendor_name = rule.value.vendor_name
                    name = rule.value.group_name
                }
            }
        }
    }
}