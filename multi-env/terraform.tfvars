AWSRegion = "sa-east-1"

# -----------------------------  STG  ----------------------------- 
# Kms
AliasName = "AcessoGovBr"
AdminRoleArn = ""

# Vpc
TagName = "AcessoGovBr"
VpcCIDR = "10.48.0.0/22"
PublicSubnetsCIDRs = [
    "10.48.0.0/27",
    "10.48.0.64/27",
    "10.48.0.128/27"
]
PrivateDBSubnetsCIDRs = [
    "10.48.1.0/27",
    "10.48.1.64/27",
    "10.48.1.128/27"
]
PrivateAppSubnetsCIDRs = [
    "10.48.2.0/26",
    "10.48.2.128/26",
    "10.48.3.0/26"
]
CreateNatOnlyOnOneAZ = false
CreateVPCFlowLogsToCloudWatch = true
VPCFlowLogsLogGroupRetention = 90
VPCFlowLogsMaxAggregationInterval = 60
VPCFlowLogsTrafficType = "ALL"
TransitGatewayId = ""
TransitGatewayRouteCIDR = "10.0.0.0/8"
TransitGatewayAttachmentTagName = "AcessoGovBr-Staging"

# AuroraApplication
AppEngine = "aurora-postgresql-11.9"
AppDBInstanceClass = "db.t3.medium"
AppDBName = "Application"
AppDBBackupRetentionPeriod = 35
AppPreferredBackupWindow = "03:00-06:00"   # In UTC
AppPreferredMaintenanceWindow = "sat:07:00-sat:07:30"  # In UTC
AppSecretArn = ""
AppNumberOfInstances = 1

# AuroraAudit
AuditEngine = "aurora-postgresql-11.9"
AuditDBInstanceClass = "db.t3.medium"
AuditDBName = "Audit"
AuditDBBackupRetentionPeriod = 35
AuditPreferredBackupWindow = "03:00-06:00"   # In UTC
AuditPreferredMaintenanceWindow = "sat:07:00-sat:07:30"  # In UTC
AuditSecretArn = ""
AuditNumberOfInstances = 1

# AuroraReport
ReportEngine = "aurora-postgresql-11.9"
ReportDBInstanceClass = "db.t3.medium"
ReportDBName = "Report"
ReportDBBackupRetentionPeriod = 35
ReportPreferredBackupWindow = "03:00-06:00"   # In UTC
ReportPreferredMaintenanceWindow = "sat:07:00-sat:07:30"  # In UTC
ReportSecretArn = ""
ReportNumberOfInstances = 1

# WafPublic
Scope = "REGIONAL"
MetricName = "WebACLPublic"
RateLimit = 1000    # In a five-minutes period
RateLimitAction = "Count"
BlockIPv4 = "Yes"
BlockIPv4Addresses = [
    "1.1.1.1/32",
    "8.8.8.8/32",
    "8.8.4.4/32",
    "9.9.9.9/32"
]
AWSManagedRulesCommonRuleSetAction = "Count"
AWSManagedRulesAdminProtectionRuleSetAction = "Count"
AWSManagedRulesKnownBadInputsRuleSetAction = "Disable"
AWSManagedRulesSQLiRuleSetAction = "Disable"
AWSManagedRulesLinuxRuleSetAction = "Disable"
AWSManagedRulesUnixRuleSetAction = "Disable"
AWSManagedRulesPHPRuleSetAction = "Disable"
AWSManagedRulesAmazonIpReputationListAction = "Disable"
AWSManagedRulesAnonymousIpListAction = "Disable"
AWSManagedRulesBotControlRuleSetAction = "Disable"

# AlbPublic
PublicCertificateArn = ""
PublicScheme = "internet-facing"
PublicSslPolicy = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
PublicAccessLogsBucketPrefix = "alb-public"

# AlbPrivate
PrivateCertificateArn = ""
PrivateScheme = "internal"
PrivateSslPolicy = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
PrivateAccessLogsBucketPrefix = "alb-private"

# NlbRhds
RhdsScheme = "internal"
RhdsAccessLogsBucketPrefix ="nlb-rhds"
RhdsCrossZone = false
RhdsListenPort = 389
RhdsTargetPort = 389
RhdsTargetType = "instance"

# NlbHAproxy
HAproxyScheme = "internet-facing"
HAproxyAccessLogsBucketPrefix ="nlb-haproxy"
HAproxyCrossZone = false
HAproxyListenPort = 443
HAproxyTargetPort = 443


# -----------------------------  DEV  ----------------------------- 
# Msk
MskClusterName = "AcessoGovBr-Auditoria"
MskInstanceType = "kafka.m5.large"
MskKafkaVersion = "2.6.1"
MskNumberOfNodes = 3
MskEBSVolumeSize = 100

# Elasticsearch
EsDomainName = "acessogovbr-elasticsearch"
EsElasticsearchVersion = "7.10"
EsInstanceType = "t3.medium.elasticsearch"
EsInstanceCount = 2
EsZoneAwarenessEnabled = true
EsDedicatedMasterEnabled = true
EsDedicatedMasterType = "t3.medium.elasticsearch"
EsDedicatedMasterCount = 3
EsSecretName = "AuroraDBSecret"
EsVolumeSize = 100
EsVolumeType = "gp2"

# Efs
EfsFileSystemName = "acessoGovBrFS"
EfsPerformanceMode = "generalPurpose"
EfsThroughputMode = "bursting"
EfsProvisionedThroughputInMibps = 10
EfsFileSharePort = 2049

# CloudTrail
CloudTrailEnableLogFileValidation = true
CloudTrailIncludeGlobalEvents = true
CloudTrailMultiRegion = true
CloudTrailPublishToTopic = true
CloudTrailNotificationEmail = ""
CloudTrailKMSArn = ""

# Config
ConfigAllSupported = true
ConfigIncludeGlobalResourceTypes = true
ConfigResourceTypes = []
ConfigKMSArn = ""
ConfigDeliveryChannelName = ""
ConfigFrequency = 24
ConfigTopicArn = ""
ConfigNotificationEmail = ""