module "CloudTrail" {
    source = "../../modules/cloudtrail"

    AWSRegion = var.AWSRegion

    EnableLogFileValidation = var.CloudTrailEnableLogFileValidation
    IncludeGlobalEvents = var.CloudTrailIncludeGlobalEvents
    MultiRegion = var.CloudTrailMultiRegion
    PublishToTopic = var.CloudTrailPublishToTopic
    NotificationEmail = var.CloudTrailNotificationEmail
    KMSId = var.CloudTrailKMSArn
}

module "Config" {
    source = "../../modules/config"

    AWSRegion = var.AWSRegion

    AllSupported = var.ConfigAllSupported
    IncludeGlobalResourceTypes = var.ConfigIncludeGlobalResourceTypes
    ResourceTypes = var.ConfigResourceTypes
    KMSId = var.ConfigKMSArn
    DeliveryChannelName = var.ConfigDeliveryChannelName
    Frequency = var.ConfigFrequency
    TopicArn = var.ConfigTopicArn
    NotificationEmail = var.ConfigNotificationEmail
}