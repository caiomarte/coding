variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "EnableLogFileValidation"{
    type = bool
    default = false
    description= "Indicates whether CloudTrail validates the integrity of log files."
}

variable "IncludeGlobalEvents"{
    type = bool
    default = false
    description = "Indicates whether the trail is publishing events from global services, such as IAM, to the log files."
}

variable "MultiRegion"{
    type =  bool
    default = false
    description = "Indicates whether the CloudTrail trail is created in the region in which you create the stack (false) or in all regions (true)."
}

variable "KMSId"{
    type = string
    default =" KMS Key ARN"
}

variable "PublishToTopic"{
    type = bool
    default = false
    description = "Indicates whether notifications are published to SNS."
}

variable "NotificationEmail"{
    type = string
    default =  ""
    description = "Email address for notifications (for new topics)."
}