variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

# CloudTrail
variable "CloudTrailEnableLogFileValidation"{
    type = bool
    default = false
    description= "Indicates whether CloudTrail validates the integrity of log files."
}

variable "CloudTrailIncludeGlobalEvents"{
    type = bool
    default = false
    description = "Indicates whether the trail is publishing events from global services, such as IAM, to the log files."
}

variable "CloudTrailMultiRegion"{
    type =  bool
    default = false
    description = "Indicates whether the CloudTrail trail is created in the region in which you create the stack (false) or in all regions (true)."
}

variable "CloudTrailPublishToTopic"{
    type = bool
    default = false
    description = "Indicates whether notifications are published to SNS."
}

variable "CloudTrailNotificationEmail"{
    type = string
    default =  ""
    description = "Email address for notifications (for new topics)."
}

variable "CloudTrailKMSArn"{
    type = string
    default =" KMS Key ARN"
}

# Config
variable "ConfigAllSupported" {
    description = "Indicates whether to record all supported resource types."
    type = bool
    default = true
}

variable "ConfigIncludeGlobalResourceTypes" {
    description = "Indicates whether AWS Config records all supported global resource types."
    type = bool
    default = true
}

variable "ConfigResourceTypes" {
    description = "A list of valid AWS resource types to include in this recording group, such as AWS::EC2::Instance or AWS::CloudTrail::Trail."
    type = list(string)
    default = []
}

variable "ConfigKMSArn" {
    description = "KMS key."
    type = string
    default = ""
}

variable "ConfigDeliveryChannelName" {
    description = "The name of the delivery channel."
    type = string
    default = ""
}

variable "ConfigFrequency" {
    description = "The frequency with which AWS Config delivers configuration snapshots."
    type = number
    default = 24

    validation {
        condition = contains([1, 3, 6, 12, 24], var.ConfigFrequency)
        error_message = "Must be either 1, 3, 6, 12, or 24."
    }
}

variable "ConfigTopicArn" {
    description = "The Amazon Resource Name (ARN) of the Amazon Simple Notification Service (Amazon SNS) topic that AWS Config delivers notifications to."
    type = string
    default = ""
}

variable "ConfigNotificationEmail" {
    description = "Email address for AWS Config notifications (for new topics)."
    type = string
    default = ""
}