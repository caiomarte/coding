module "stg" {
    source = "./environments/stg"

    AWSRegion = var.AWSRegion

    # Kms
    AliasName = var.AliasName
    AdminRoleArn = var.AdminRoleArn

    # Vpc
    TagName = var.TagName
    VpcCIDR = var.VpcCIDR
    PublicSubnetsCIDRs = var.PublicSubnetsCIDRs
    PrivateDBSubnetsCIDRs = var.PrivateDBSubnetsCIDRs
    PrivateAppSubnetsCIDRs = var.PrivateAppSubnetsCIDRs
    CreateNatOnlyOnOneAZ = var.CreateNatOnlyOnOneAZ
    CreateVPCFlowLogsToCloudWatch = var.CreateVPCFlowLogsToCloudWatch
    VPCFlowLogsLogGroupRetention = var.VPCFlowLogsLogGroupRetention
    VPCFlowLogsMaxAggregationInterval = var.VPCFlowLogsMaxAggregationInterval
    VPCFlowLogsTrafficType = var.VPCFlowLogsTrafficType
    TransitGatewayId = var.TransitGatewayId
    TransitGatewayRouteCIDR = var.TransitGatewayRouteCIDR
    TransitGatewayAttachmentTagName = var.TransitGatewayAttachmentTagName

    # AuroraApplication
    AppEngine = var.AppEngine
    AppDBInstanceClass = var.AppDBInstanceClass
    AppDBName = var.AppDBName
    AppDBBackupRetentionPeriod = var.AppDBBackupRetentionPeriod
    AppPreferredBackupWindow = var.AppPreferredBackupWindow
    AppPreferredMaintenanceWindow = var.AppPreferredMaintenanceWindow
    AppSecretArn = var.AppSecretArn
    AppNumberOfInstances = var.AppNumberOfInstances

    # AuroraAudit
    AuditEngine = var.AuditEngine
    AuditDBInstanceClass = var.AuditDBInstanceClass
    AuditDBName = var.AuditDBName
    AuditDBBackupRetentionPeriod = var.AuditDBBackupRetentionPeriod
    AuditPreferredBackupWindow = var.AuditPreferredBackupWindow
    AuditPreferredMaintenanceWindow = var.AuditPreferredMaintenanceWindow
    AuditSecretArn = var.AuditSecretArn
    AuditNumberOfInstances = var.AuditNumberOfInstances

    # AuroraReport
    ReportEngine = var.ReportEngine
    ReportDBInstanceClass = var.ReportDBInstanceClass
    ReportDBName = var.ReportDBName
    ReportDBBackupRetentionPeriod = var.ReportDBBackupRetentionPeriod
    ReportPreferredBackupWindow = var.ReportPreferredBackupWindow
    ReportPreferredMaintenanceWindow = var.ReportPreferredMaintenanceWindow
    ReportSecretArn = var.ReportSecretArn
    ReportNumberOfInstances = var.ReportNumberOfInstances

    # WafPublic
    Scope = var.Scope
    MetricName = var.MetricName
    RateLimit = var.RateLimit
    RateLimitAction = var.RateLimitAction
    BlockIPv4 = var.BlockIPv4
    BlockIPv4Addresses = var.BlockIPv4Addresses
    AWSManagedRulesCommonRuleSetAction = var.AWSManagedRulesCommonRuleSetAction
    AWSManagedRulesAdminProtectionRuleSetAction = var.AWSManagedRulesAdminProtectionRuleSetAction
    AWSManagedRulesKnownBadInputsRuleSetAction = var.AWSManagedRulesKnownBadInputsRuleSetAction
    AWSManagedRulesSQLiRuleSetAction = var.AWSManagedRulesSQLiRuleSetAction
    AWSManagedRulesLinuxRuleSetAction = var.AWSManagedRulesLinuxRuleSetAction
    AWSManagedRulesUnixRuleSetAction = var.AWSManagedRulesUnixRuleSetAction
    AWSManagedRulesPHPRuleSetAction = var.AWSManagedRulesPHPRuleSetAction
    AWSManagedRulesAmazonIpReputationListAction = var.AWSManagedRulesAmazonIpReputationListAction
    AWSManagedRulesAnonymousIpListAction = var.AWSManagedRulesAnonymousIpListAction
    AWSManagedRulesBotControlRuleSetAction = var.AWSManagedRulesBotControlRuleSetAction

    # AlbPublic
    PublicCertificateArn = var.PublicCertificateArn
    PublicScheme = var.PublicScheme
    PublicSslPolicy = var.PublicSslPolicy
    PublicAccessLogsBucketPrefix = var.PublicAccessLogsBucketPrefix

    # AlbPrivate
    PrivateCertificateArn = var.PrivateCertificateArn
    PrivateScheme = var.PrivateScheme
    PrivateSslPolicy = var.PrivateSslPolicy
    PrivateAccessLogsBucketPrefix = var.PrivateAccessLogsBucketPrefix

    # NlbRhds
    RhdsScheme = var.RhdsScheme
    RhdsAccessLogsBucketPrefix = var.RhdsAccessLogsBucketPrefix
    RhdsCrossZone = var.RhdsCrossZone
    RhdsListenPort = var.RhdsListenPort
    RhdsTargetPort = var.RhdsTargetPort
    RhdsTargetType = var.RhdsTargetType

    # NlbHAproxy
    HAproxyScheme = var.HAproxyScheme
    HAproxyAccessLogsBucketPrefix = var.HAproxyAccessLogsBucketPrefix
    HAproxyCrossZone = var.HAproxyCrossZone
    HAproxyListenPort = var.HAproxyListenPort
    HAproxyTargetPort = var.HAproxyTargetPort
}

module "dev" {
    source = "./environments/dev"

    AWSRegion = var.AWSRegion

    VPCID = module.stg.VPCID
    VpcCIDR = module.stg.VpcCIDR
    PrivateAppSubnet1 = module.stg.PrivateAppSubnet1
    PrivateAppSubnet2 = module.stg.PrivateAppSubnet2
    PrivateAppSubnet3 = module.stg.PrivateAppSubnet3
    KMSArn = module.stg.KeyArn

    # Msk
    MskClusterName = var.MskClusterName
    MskInstanceType = var.MskInstanceType
    MskKafkaVersion = var.MskKafkaVersion
    MskNumberOfNodes = var.MskNumberOfNodes
    MskEBSVolumeSize = var.MskEBSVolumeSize

    # Elasticsearch
    EsDomainName = var.EsDomainName
    EsElasticsearchVersion = var.EsElasticsearchVersion
    EsInstanceType = var.EsInstanceType
    EsInstanceCount = var.EsInstanceCount
    EsZoneAwarenessEnabled = var.EsZoneAwarenessEnabled
    EsDedicatedMasterEnabled = var.EsDedicatedMasterEnabled
    EsDedicatedMasterType = var.EsDedicatedMasterType
    EsDedicatedMasterCount = var.EsDedicatedMasterCount
    EsSecretName = var.EsSecretName
    EsVolumeSize = var.EsVolumeSize
    EsVolumeType = var.EsVolumeType

    # Efs
    EfsFileSystemName = var.EfsFileSystemName
    EfsPerformanceMode = var.EfsPerformanceMode
    EfsThroughputMode = var.EfsThroughputMode
    EfsProvisionedThroughputInMibps = var.EfsProvisionedThroughputInMibps
    EfsFileSharePort = var.EfsFileSharePort
}

module "rmd" {
    source = "./environments/rmd"

    AWSRegion = var.AWSRegion

    # CloudTrail
    CloudTrailEnableLogFileValidation = var.CloudTrailEnableLogFileValidation
    CloudTrailIncludeGlobalEvents = var.CloudTrailIncludeGlobalEvents
    CloudTrailMultiRegion = var.CloudTrailMultiRegion
    CloudTrailPublishToTopic = var.CloudTrailPublishToTopic
    CloudTrailNotificationEmail = var.CloudTrailNotificationEmail
    CloudTrailKMSArn = var.CloudTrailKMSArn

    # Config
    ConfigAllSupported = var.ConfigAllSupported
    ConfigIncludeGlobalResourceTypes = var.ConfigIncludeGlobalResourceTypes
    ConfigResourceTypes = var.ConfigAllSupported ? [] : var.ConfigResourceTypes
    ConfigKMSArn = var.ConfigKMSArn
    ConfigDeliveryChannelName = var.ConfigDeliveryChannelName
    ConfigFrequency = var.ConfigFrequency
    ConfigTopicArn = var.ConfigTopicArn
    ConfigNotificationEmail = var.ConfigNotificationEmail
}