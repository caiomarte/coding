variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "Engine" {
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
            ], var.Engine
        )
        error_message = "Must be a valid Aurora engine and version."
    }
}

variable "DBInstanceClass" {
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
            ], var.DBInstanceClass
        )
        error_message = "Must be a valid DB instance type."
    }
}

variable "DBName" {
    description = "Name of the database."
    type = string
}

variable "DBBackupRetentionPeriod" {
    description = "The number of days to keep snapshots of the cluster."
    type = string
    default = 35

    validation {
        condition = var.DBBackupRetentionPeriod >= 1 && var.DBBackupRetentionPeriod <= 35
        error_message = "MinValue: 1, MaxValue: 35."
    }
}

variable "PreferredBackupWindow" {
    description = "The daily time range in UTC during which you want to create automated backups."
    type = string
    default = "09:54-10:24"
}

variable "PreferredMaintenanceWindow" {
    description = "The weekly time range (in UTC) during which system maintenance can occur."
    type = string
    default = "sat:07:00-sat:07:30"
}

variable "SecretArn" {
    type = string
    default = ""
}

variable "KmsArn" {
    type = string
    default = ""
}

variable "VpcId" {
    type = string
}

variable "SubnetIds" {
    type = list(string)
}

variable "NumberOfInstances" {
    description = "Number of instances to create."
    type = number
    default = 1

    validation {
        condition = var.NumberOfInstances >= 1 && var.NumberOfInstances <= 3
        error_message = "Must be a number between 1 and 3."
    }
}