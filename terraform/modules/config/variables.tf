variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "AllSupported" {
    description = "Indicates whether to record all supported resource types."
    type = bool
    default = true
}

variable "IncludeGlobalResourceTypes" {
    description = "Indicates whether AWS Config records all supported global resource types."
    type = bool
    default = true
}

variable "ResourceTypes" {
    description = "A list of valid AWS resource types to include in this recording group, such as AWS::EC2::Instance or AWS::CloudTrail::Trail."
    type = list(string)
    default = []
}

variable "KMSId" {
    description = "KMS key."
    type = string
    default = ""
}

variable "DeliveryChannelName" {
    description = "The name of the delivery channel."
    type = string
    default = ""
}

variable "Frequency" {
    description = "The frequency with which AWS Config delivers configuration snapshots."
    type = number
    default = 24

    validation {
        condition = contains([1, 3, 6, 12, 24], var.Frequency)
        error_message = "Must be either 1, 3, 6, 12, or 24."
    }
}

variable "TopicArn" {
    description = "The Amazon Resource Name (ARN) of the Amazon Simple Notification Service (Amazon SNS) topic that AWS Config delivers notifications to."
    type = string
    default = ""
}

variable "NotificationEmail" {
    description = "Email address for AWS Config notifications (for new topics)."
    type = string
    default = ""
}