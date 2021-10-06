module "Kms" {
    source = "../../modules/kms"

    AWSRegion = var.AWSRegion

    AliasName = var.AliasName
    AdminRoleArn = var.AdminRoleArn  
}

module "Vpc" {
    source = "../../modules/vpc"

    AWSRegion = var.AWSRegion

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

    VPCFlowLogsCloudWatchKMSKey = module.Kms.KeyArn
}

module "S3VpcEndpoint" {
    source = "../../modules/s3-vpc-endpoint"

    AWSRegion = var.AWSRegion

    VPCID = module.Vpc.VPCID
    RouteTables = module.Vpc.AllRouteTables
}

module "AuroraApplication" {
    source = "../../modules/aurora"

    AWSRegion = var.AWSRegion
    
    Engine = var.AppEngine
    DBInstanceClass = var.AppDBInstanceClass
    DBName = var.AppDBName
    DBBackupRetentionPeriod = var.AppDBBackupRetentionPeriod
    PreferredBackupWindow = var.AppPreferredBackupWindow
    PreferredMaintenanceWindow = var.AppPreferredMaintenanceWindow
    SecretArn = var.AppSecretArn
    NumberOfInstances = var.AppNumberOfInstances

    KmsArn = module.Kms.KeyArn
    VpcId = module.Vpc.VPCID
    SubnetIds = module.Vpc.PrivateSubnetsDB
}

module "AuroraAudit" {
    source = "../../modules/aurora"

    AWSRegion = var.AWSRegion
    
    Engine = var.AuditEngine
    DBInstanceClass = var.AuditDBInstanceClass
    DBName = var.AuditDBName
    DBBackupRetentionPeriod = var.AuditDBBackupRetentionPeriod
    PreferredBackupWindow = var.AuditPreferredBackupWindow
    PreferredMaintenanceWindow = var.AuditPreferredMaintenanceWindow
    SecretArn = var.AuditSecretArn
    NumberOfInstances = var.AuditNumberOfInstances

    KmsArn = module.Kms.KeyArn
    VpcId = module.Vpc.VPCID
    SubnetIds = module.Vpc.PrivateSubnetsDB
}

module "AuroraReport" {
    source = "../../modules/aurora"

    AWSRegion = var.AWSRegion
    
    Engine = var.ReportEngine
    DBInstanceClass = var.ReportDBInstanceClass
    DBName = var.ReportDBName
    DBBackupRetentionPeriod = var.ReportDBBackupRetentionPeriod
    PreferredBackupWindow = var.ReportPreferredBackupWindow
    PreferredMaintenanceWindow = var.ReportPreferredMaintenanceWindow
    SecretArn = var.ReportSecretArn
    NumberOfInstances = var.ReportNumberOfInstances

    KmsArn = module.Kms.KeyArn
    VpcId = module.Vpc.VPCID
    SubnetIds = module.Vpc.PrivateSubnetsDB
}

module "ElbAccessLogs" {
    source = "../../modules/elb-accesslogs"

    AWSRegion = var.AWSRegion
}

module "WafPublic" {
    source = "../../modules/waf"

    AWSRegion = var.AWSRegion

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
}

module "AlbPublic" {
    source = "../../modules/alb-public"

    AWSRegion = var.AWSRegion

    CertificateArn = var.PublicCertificateArn
    Scheme = var.PublicScheme
    SslPolicy = var.PublicSslPolicy
    AccessLogsBucketPrefix = var.PublicAccessLogsBucketPrefix

    VPCID = module.Vpc.VPCID
    Subnets = module.Vpc.PublicSubnets
    WebACLArn = module.WafPublic.WebACLArn
    AccessLogsBucketName = module.ElbAccessLogs.BucketName
}

module "AlbPrivate" {
    source = "../../modules/alb-private"

    AWSRegion = var.AWSRegion

    CertificateArn = var.PrivateCertificateArn
    Scheme = var.PrivateScheme
    SslPolicy = var.PrivateSslPolicy
    AccessLogsBucketPrefix = var.PrivateAccessLogsBucketPrefix

    VPCID = module.Vpc.VPCID
    Subnets = module.Vpc.PrivateSubnetsApp
    AccessLogsBucketName = module.ElbAccessLogs.BucketName
}

module "NlbRhds" {
    source = "../../modules/nlb"

    AWSRegion = var.AWSRegion
    
    Scheme = var.RhdsScheme
    AccessLogsBucketPrefix = var.RhdsAccessLogsBucketPrefix
    CrossZone = var.RhdsCrossZone
    ListenPort = var.RhdsListenPort
    TargetPort = var.RhdsTargetPort
    TargetType = var.RhdsTargetType

    VPCID = module.Vpc.VPCID
    Subnets = module.Vpc.PrivateSubnetsApp
    AccessLogsBucketName = module.ElbAccessLogs.BucketName
}

module "NlbHAproxy" {
    source = "../../modules/nlb"

    AWSRegion = var.AWSRegion
    
    Scheme = var.HAproxyScheme
    AccessLogsBucketPrefix = var.HAproxyAccessLogsBucketPrefix
    CrossZone = var.HAproxyCrossZone
    ListenPort = var.HAproxyListenPort
    TargetPort = var.HAproxyTargetPort

    TargetType = "instance"
    VPCID = module.Vpc.VPCID
    Subnets = module.Vpc.PublicSubnets
    AccessLogsBucketName = module.ElbAccessLogs.BucketName
}