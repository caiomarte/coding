variable "AWSRegion" {
    type = string
    description = "Inform the AWS Region to deploy resources to."
}

variable "VpcCIDR" {
    description = "Please enter the IP range (CIDR notation) for this VPC."
    type = string
    default = "10.0.0.0/16"
}

variable "PrivateAppSubnetsCIDRs" {
    description = "Please enter a list of IP ranges (CIDR notation) for app private subnets."
    type = list(string)
    default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "PrivateDBSubnetsCIDRs" {
    description = "Please enter a list of IP ranges (CIDR notation) for DB private subnets."
    type = list(string)
    default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "PublicSubnetsCIDRs" {
    description = "Please enter a list of IP ranges (CIDR notation) for public subnets."
    type = list(string)
    default = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
}

variable "CreateNatOnlyOnOneAZ" {
    description = "Set to true to create NAT Gateway only on one AZ. If false, each AZ will have its own NAT Gateway."
    type = bool
    default = false
}

variable "CreateVPCFlowLogsToCloudWatch" {
    description = "Set to true to create VPC flow logs for the VPC and publish them to CloudWatch. If false, VPC flow logs will not be created."
    type = bool
    default = false
}

variable "VPCFlowLogsCloudWatchKMSKey" {
    description = "(Optional) KMS Key ARN to use for encrypting the VPC flow logs data. If empty, encryption is enabled with CloudWatch Logs managing the server-side encryption keys."
    type = string
    default = ""

    validation {
        condition = can(regex("^$|^arn:(aws[a-zA-Z-]*)?:kms:[a-z0-9-]+:\\d{12}:key\\/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.VPCFlowLogsCloudWatchKMSKey))
        error_message = "Must be a valid KMS Key ARN. Key ARN example:  arn:aws:kms:us-east-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab."
    }
}

variable "VPCFlowLogsLogGroupRetention" {
    description = "Number of days to retain the VPC Flow Logs in CloudWatch."
    type = number
    default = 14

    validation {
        condition = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.VPCFlowLogsLogGroupRetention)
        error_message = "Must be either 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, or 3653."
    }
}

variable "VPCFlowLogsMaxAggregationInterval" {
    description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. You can specify 60 seconds (1 minute) or 600 seconds (10 minutes)."
    type = number
    default = 600

    validation {
        condition = contains([60, 600], var.VPCFlowLogsMaxAggregationInterval)
        error_message = "Must be either 60 or 600."
    }
}

variable "VPCFlowLogsTrafficType" {
    description = "The type of traffic to log. You can log traffic that the resource accepts or rejects, or all traffic."
    type = string
    default = "REJECT"

    validation {
        condition = contains(["ACCEPT", "ALL", "REJECT"], var.VPCFlowLogsTrafficType)
        error_message = "Must be either ACCEPT, ALL, or REJECT."
    }
}

variable "TagName" {
    description = "Value to be used on Tag Name for VPC and Internet Gateway."
    type = string
}

variable "TransitGatewayId" {
    description = "Transit Gateway ID to attach this VPC."
    type = string
}

variable "TransitGatewayRouteCIDR" {
    description = "Please enter the IP range (CIDR notation) for Transit Gateway route."
    type = string
}

variable "TransitGatewayAttachmentTagName" {
    description = "Value to be used on Tag Name for Transit Gateway Attachment."
    type = string
}