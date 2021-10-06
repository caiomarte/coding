variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to."
}

variable "Scope" {
    description = "WebACL Scope."
    type = string
    default = "REGIONAL"

    validation {
        condition = contains(["REGIONAL", "CLOUDFRONT"], var.Scope)
        # For CLOUDFRONT, you must create your WAFv2 resources in the US East (N. Virginia) Region, us-east-1.
        error_message = "Must be either REGIONAL or CLOUDFRONT."
    }
}

variable "MetricName" {
    description = "Metric name for CloudWatch Metrics."
    type = string
    default = "WebACLMetric"
}

variable "RateLimit" {
    description = "The maximum number of requests from a single IP address that are allowed in a five-minutes period."
    type = number
    default = 100

    validation {
        condition = var.RateLimit >= 100 && var.RateLimit <= 20000000
        error_message = "MinValue: 100, MaxValue: 20000000."
    }
}

variable "RateLimitAction" {
    description = "Block or count requests that exceed the rate limit. Alterantively, disable rate limiting at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.RateLimitAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "BlockIPv4" {
    description = "Block IPv4 addresses?"
    type = string
    default = "No"

    validation {
        condition = contains(["Yes", "No"], var.BlockIPv4)
        error_message = "Must be either Yes or No."
    }
}

variable "BlockIPv4Addresses" {
    type = list(string)
    default = []
}

variable "AWSManagedRulesCommonRuleSetAction" {
    description = "Block or count AWSManagedRulesCommonRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesCommonRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesAdminProtectionRuleSetAction" {
    description = "Block or count AWSManagedRulesAdminProtectionRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"
    
    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesAdminProtectionRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesKnownBadInputsRuleSetAction" {
    description = "Block or count AWSManagedRulesKnownBadInputsRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesKnownBadInputsRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesSQLiRuleSetAction" {
    description = "Block or count AWSManagedRulesSQLiRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesSQLiRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesLinuxRuleSetAction" {
    description = "Block or count AWSManagedRulesLinuxRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesLinuxRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesUnixRuleSetAction" {
    description = "Block or count AWSManagedRulesUnixRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesUnixRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesPHPRuleSetAction" {
    description = "Block or count AWSManagedRulesPHPRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesPHPRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesAmazonIpReputationListAction" {
    description = "Block or count AWSManagedRulesAmazonIpReputationList. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesAmazonIpReputationListAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesAnonymousIpListAction" {
    description = "Block or count AWSManagedRulesAnonymousIpList. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesAnonymousIpListAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}

variable "AWSManagedRulesBotControlRuleSetAction" {
    description = "Block or count AWSManagedRulesBotControlRuleSet. Alterantively, disable at all."
    type = string
    default = "Disable"

    validation {
        condition = contains(["Disable", "Block", "Count"], var.AWSManagedRulesBotControlRuleSetAction)
        error_message = "Must be either Disable, Block, or Count."
    }
}