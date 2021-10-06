variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

# STG
variable "AliasName" {
    description = "Key alias name."
    type = string
    default = "AcessoGovBr"
}

variable "AdminRoleArn" {
    description = "ARN of Admin role."
    type = string
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

variable "AppEngine" {
    description = "Aurora engine and version"
    type = string

    validation {
        condition = contains(
            [
                "5.6.mysql-aurora.1.19.1",      # aws rds describe-db-engine-versions --engine aurora --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "5.6.mysql_aurora.1.23.2",
                "5.7.mysql-aurora.2.03.4",      # aws rds describe-db-engine-versions --engine aurora-mysql --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "5.7.mysql-aurora.2.04.3",
                "5.7.mysql_aurora.2.09.2",
                "aurora-postgresql-10.11",      # aws rds describe-db-engine-versions --engine aurora-postgresql --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "aurora-postgresql-10.12",
                "aurora-postgresql-10.13",
                "aurora-postgresql-10.14",
                "aurora-postgresql-10.16",
                "aurora-postgresql-11.6",
                "aurora-postgresql-11.7",
                "aurora-postgresql-11.8",
                "aurora-postgresql-11.9",
                "aurora-postgresql-11.11",
                "aurora-postgresql-12.4",
                "aurora-postgresql-12.6"
            ], var.AppEngine
        )
        error_message = "Must be a valid Aurora engine and version."
    }
}

variable "AppDBInstanceClass" {
    description = "The instance type of database server (see https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html)."
    type = string
    default = "db.r5.large"

    validation {
        condition = contains(
            [
                # t3
                "db.t3.medium",
                "db.t3.large",
                # r5
                "db.r5.large",
                "db.r5.xlarge",
                "db.r5.2xlarge",
                "db.r5.4xlarge",
                "db.r5.8xlarge",
                "db.r5.12xlarge",
                "db.r5.16xlarge",
                "db.r5.24xlarge",
                # r6g
                "db.r6g.large",
                "db.r6g.xlarge",
                "db.r6g.2xlarge",
                "db.r6g.4xlarge",
                "db.r6g.8xlarge",
                "db.r6g.12xlarge",
                "db.r6g.16xlarge"
            ], var.AppDBInstanceClass
        )
        error_message = "Must be a valid DB instance type."
    }
}

variable "AppDBName" {
    description = "Name of the database."
    type = string
}

variable "AppDBBackupRetentionPeriod" {
    description = "The number of days to keep snapshots of the cluster."
    type = string
    default = 35

    validation {
        condition = var.AppDBBackupRetentionPeriod >= 1 && var.AppDBBackupRetentionPeriod <= 35
        error_message = "MinValue: 1, MaxValue: 35."
    }
}

variable "AppPreferredBackupWindow" {
    description = "The daily time range in UTC during which you want to create automated backups."
    type = string
    default = "09:54-10:24"
}

variable "AppPreferredMaintenanceWindow" {
    description = "The weekly time range (in UTC) during which system maintenance can occur."
    type = string
    default = "sat:07:00-sat:07:30"
}

variable "AppSecretArn" {
    type = string
    default = ""
}

variable "AppNumberOfInstances" {
    description = "Number of instances to create."
    type = number
    default = 1

    validation {
        condition = var.AppNumberOfInstances >= 1 && var.AppNumberOfInstances <= 3
        error_message = "Must be a number between 1 and 3."
    }
}

variable "AuditEngine" {
    description = "Aurora engine and version"
    type = string

    validation {
        condition = contains(
            [
                "5.6.mysql-aurora.1.19.1",      # aws rds describe-db-engine-versions --engine aurora --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "5.6.mysql_aurora.1.23.2",
                "5.7.mysql-aurora.2.03.4",      # aws rds describe-db-engine-versions --engine aurora-mysql --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "5.7.mysql-aurora.2.04.3",
                "5.7.mysql_aurora.2.09.2",
                "aurora-postgresql-10.11",      # aws rds describe-db-engine-versions --engine aurora-postgresql --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "aurora-postgresql-10.12",
                "aurora-postgresql-10.13",
                "aurora-postgresql-10.14",
                "aurora-postgresql-10.16",
                "aurora-postgresql-11.6",
                "aurora-postgresql-11.7",
                "aurora-postgresql-11.8",
                "aurora-postgresql-11.9",
                "aurora-postgresql-11.11",
                "aurora-postgresql-12.4",
                "aurora-postgresql-12.6"
            ], var.AuditEngine
        )
        error_message = "Must be a valid Aurora engine and version."
    }
}

variable "AuditDBInstanceClass" {
    description = "The instance type of database server (see https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html)."
    type = string
    default = "db.r5.large"

    validation {
        condition = contains(
            [
                # t3
                "db.t3.medium",
                "db.t3.large",
                # r5
                "db.r5.large",
                "db.r5.xlarge",
                "db.r5.2xlarge",
                "db.r5.4xlarge",
                "db.r5.8xlarge",
                "db.r5.12xlarge",
                "db.r5.16xlarge",
                "db.r5.24xlarge",
                # r6g
                "db.r6g.large",
                "db.r6g.xlarge",
                "db.r6g.2xlarge",
                "db.r6g.4xlarge",
                "db.r6g.8xlarge",
                "db.r6g.12xlarge",
                "db.r6g.16xlarge"
            ], var.AuditDBInstanceClass
        )
        error_message = "Must be a valid DB instance type."
    }
}

variable "AuditDBName" {
    description = "Name of the database."
    type = string
}

variable "AuditDBBackupRetentionPeriod" {
    description = "The number of days to keep snapshots of the cluster."
    type = string
    default = 35

    validation {
        condition = var.AuditDBBackupRetentionPeriod >= 1 && var.AuditDBBackupRetentionPeriod <= 35
        error_message = "MinValue: 1, MaxValue: 35."
    }
}

variable "AuditPreferredBackupWindow" {
    description = "The daily time range in UTC during which you want to create automated backups."
    type = string
    default = "09:54-10:24"
}

variable "AuditPreferredMaintenanceWindow" {
    description = "The weekly time range (in UTC) during which system maintenance can occur."
    type = string
    default = "sat:07:00-sat:07:30"
}

variable "AuditSecretArn" {
    type = string
    default = ""
}

variable "AuditNumberOfInstances" {
    description = "Number of instances to create."
    type = number
    default = 1

    validation {
        condition = var.AuditNumberOfInstances >= 1 && var.AuditNumberOfInstances <= 3
        error_message = "Must be a number between 1 and 3."
    }
}

variable "ReportEngine" {
    description = "Aurora engine and version"
    type = string

    validation {
        condition = contains(
            [
                "5.6.mysql-aurora.1.19.1",      # aws rds describe-db-engine-versions --engine aurora --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "5.6.mysql_aurora.1.23.2",
                "5.7.mysql-aurora.2.03.4",      # aws rds describe-db-engine-versions --engine aurora-mysql --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "5.7.mysql-aurora.2.04.3",
                "5.7.mysql_aurora.2.09.2",
                "aurora-postgresql-10.11",      # aws rds describe-db-engine-versions --engine aurora-postgresql --query 'DBEngineVersions[?contains(SupportedEngineModes,`provisioned`)].EngineVersion'
                "aurora-postgresql-10.12",
                "aurora-postgresql-10.13",
                "aurora-postgresql-10.14",
                "aurora-postgresql-10.16",
                "aurora-postgresql-11.6",
                "aurora-postgresql-11.7",
                "aurora-postgresql-11.8",
                "aurora-postgresql-11.9",
                "aurora-postgresql-11.11",
                "aurora-postgresql-12.4",
                "aurora-postgresql-12.6"
            ], var.ReportEngine
        )
        error_message = "Must be a valid Aurora engine and version."
    }
}

variable "ReportDBInstanceClass" {
    description = "The instance type of database server (see https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html)."
    type = string
    default = "db.r5.large"

    validation {
        condition = contains(
            [
                # t3
                "db.t3.medium",
                "db.t3.large",
                # r5
                "db.r5.large",
                "db.r5.xlarge",
                "db.r5.2xlarge",
                "db.r5.4xlarge",
                "db.r5.8xlarge",
                "db.r5.12xlarge",
                "db.r5.16xlarge",
                "db.r5.24xlarge",
                # r6g
                "db.r6g.large",
                "db.r6g.xlarge",
                "db.r6g.2xlarge",
                "db.r6g.4xlarge",
                "db.r6g.8xlarge",
                "db.r6g.12xlarge",
                "db.r6g.16xlarge"
            ], var.ReportDBInstanceClass
        )
        error_message = "Must be a valid DB instance type."
    }
}

variable "ReportDBName" {
    description = "Name of the database."
    type = string
}

variable "ReportDBBackupRetentionPeriod" {
    description = "The number of days to keep snapshots of the cluster."
    type = string
    default = 35

    validation {
        condition = var.ReportDBBackupRetentionPeriod >= 1 && var.ReportDBBackupRetentionPeriod <= 35
        error_message = "MinValue: 1, MaxValue: 35."
    }
}

variable "ReportPreferredBackupWindow" {
    description = "The daily time range in UTC during which you want to create automated backups."
    type = string
    default = "09:54-10:24"
}

variable "ReportPreferredMaintenanceWindow" {
    description = "The weekly time range (in UTC) during which system maintenance can occur."
    type = string
    default = "sat:07:00-sat:07:30"
}

variable "ReportSecretArn" {
    type = string
    default = ""
}

variable "ReportNumberOfInstances" {
    description = "Number of instances to create."
    type = number
    default = 1

    validation {
        condition = var.ReportNumberOfInstances >= 1 && var.ReportNumberOfInstances <= 3
        error_message = "Must be a number between 1 and 3."
    }
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

variable "PublicCertificateArn" {
    description = "ACM ARN to use for HTTPS listener."
    type = string

    validation {
        condition = can(regex("^arn:(aws[a-zA-Z-]*)?:acm:[a-z0-9-]+:\\d{12}:certificate\\/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.PublicCertificateArn))
        error_message = "Must be a valid Certificate ARN. Certificate ARN example: arn:aws:acm:sa-east-1:111122223333:certificate/1234abcd-12ab-34cd-56ef-1234567890ab."
    }
}

variable "PublicScheme" {
    description = "ALB scheme."
    type = string

    validation {
        condition = contains(["internet-facing", "internal"], var.PublicScheme)
        error_message = "Must be a valid ALB scheme - (internet-facing, internal)."
    }
}

variable "PublicSslPolicy" {
    description = "ALB SSL policy. Reference: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html."
    type = string
    default = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

    validation {
        condition = contains([
            "ELBSecurityPolicy-2016-08",
            "ELBSecurityPolicy-TLS-1-0-2015-04",
            "ELBSecurityPolicy-TLS-1-1-2017-01",
            "ELBSecurityPolicy-TLS-1-2-2017-01",
            "ELBSecurityPolicy-TLS-1-2-Ext-2018-06",
            "ELBSecurityPolicy-FS-2018-06",
            "ELBSecurityPolicy-FS-1-1-2019-08",
            "ELBSecurityPolicy-FS-1-2-2019-08",
            "ELBSecurityPolicy-FS-1-2-Res-2019-08",
            "ELBSecurityPolicy-2015-05",
            "ELBSecurityPolicy-FS-1-2-Res-2020-10"
        ], var.PublicSslPolicy)
        error_message = "Must be a valid SSL policy."
    }
}

variable "PublicAccessLogsBucketPrefix" {
    description = "Bucket prefix. It is mandatory."
    type = string
}

variable "PrivateCertificateArn" {
    description = "ACM ARN to use for HTTPS listener."
    type = string

    validation {
        condition = can(regex("^arn:(aws[a-zA-Z-]*)?:acm:[a-z0-9-]+:\\d{12}:certificate\\/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.PrivateCertificateArn))
        error_message = "Must be a valid Certificate ARN. Certificate ARN example: arn:aws:acm:sa-east-1:111122223333:certificate/1234abcd-12ab-34cd-56ef-1234567890ab."
    }
}

variable "PrivateScheme" {
    description = "ALB scheme."
    type = string

    validation {
        condition = contains(["internet-facing", "internal"], var.PrivateScheme)
        error_message = "Must be a valid ALB scheme - (internet-facing, internal)."
    }
}

variable "PrivateSslPolicy" {
    description = "ALB SSL policy. Reference: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html."
    type = string
    default = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

    validation {
        condition = contains([
            "ELBSecurityPolicy-2016-08",
            "ELBSecurityPolicy-TLS-1-0-2015-04",
            "ELBSecurityPolicy-TLS-1-1-2017-01",
            "ELBSecurityPolicy-TLS-1-2-2017-01",
            "ELBSecurityPolicy-TLS-1-2-Ext-2018-06",
            "ELBSecurityPolicy-FS-2018-06",
            "ELBSecurityPolicy-FS-1-1-2019-08",
            "ELBSecurityPolicy-FS-1-2-2019-08",
            "ELBSecurityPolicy-FS-1-2-Res-2019-08",
            "ELBSecurityPolicy-2015-05",
            "ELBSecurityPolicy-FS-1-2-Res-2020-10"
        ], var.PrivateSslPolicy)
        error_message = "Must be a valid SSL policy."
    }
}

variable "PrivateAccessLogsBucketPrefix" {
    description = "Bucket prefix. It is mandatory."
    type = string
}

variable "RhdsScheme" {
    type = string

    validation {
        condition = contains([
            "internet-facing",
            "internal"
        ], var.RhdsScheme)
        error_message = "Must be a valid ALB scheme - Internet-facing or internal."
    }
}

 variable  "RhdsAccessLogsBucketPrefix" {
    description = "Bucket prefix. It is mandatory."
    type = string
 }

 variable "RhdsCrossZone" {
    description = "Indicates whether cross-zone load balancing is enabled."
    type = bool 
    default = false 
 }

 variable "RhdsListenPort" {
    description = "Load Balancer Listen port"
    type = number
 }

 variable "RhdsTargetPort" {
    description ="Load Balancer Target port"
    type = number
 }

variable "RhdsTargetType" {
    description = "The type of target that you must specify when registering targets with this target group."
    type = string
    default = "instance"

    validation {
        condition = contains([
            "ip",
            "instance"
        ],var.RhdsTargetType)
        error_message ="Must be a valid Network Load Balancer target type."
    }
}

variable "HAproxyScheme" {
    type = string

    validation {
        condition = contains([
            "internet-facing",
            "internal"
        ], var.HAproxyScheme)
        error_message = "Must be a valid ALB scheme - Internet-facing or internal."
    }
}

variable  "HAproxyAccessLogsBucketPrefix" {
    description = "Bucket prefix. It is mandatory."
    type = string
}

variable "HAproxyCrossZone" {
    description = "Indicates whether cross-zone load balancing is enabled."
    type = bool 
    default = false 
}

variable "HAproxyListenPort" {
    description = "Load Balancer Listen port"
    type = number
}

variable "HAproxyTargetPort" {
    description ="Load Balancer Target port"
    type = number
}

# DEV
# Msk
variable "MskClusterName" {
    type = string
}

variable "MskKafkaVersion" {
    type = string
}

variable "MskNumberOfNodes" {
    type = number
}

variable "MskInstanceType" {
    type = string
}

variable "MskEBSVolumeSize" {
    type = number
}

# Elasticsearch
variable "EsDomainName" {
    type = string
}

variable "EsElasticsearchVersion" {
    type = string
}

variable "EsInstanceType" {
    type = string
}

variable "EsInstanceCount" {
    type = number
}

variable "EsZoneAwarenessEnabled" {
    type = bool
}

variable "EsDedicatedMasterEnabled" {
    type = bool
}

variable "EsDedicatedMasterType" {
    type = string
}

variable "EsDedicatedMasterCount" {
    type = number
}

variable "EsSecretName" {
    type = string
}

variable "EsVolumeSize" {
    type = number
}

variable "EsVolumeType" {
    type = string
}

# Efs
variable "EfsFileSystemName" {
    type = string
}

variable "EfsPerformanceMode" {
    type = string
}

variable "EfsThroughputMode" {
    type = string
}

variable "EfsFileSharePort" {
    type = number
}

variable "EfsProvisionedThroughputInMibps" {
    type = number
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