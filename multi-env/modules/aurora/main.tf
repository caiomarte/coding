terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = var.AWSRegion
}

data "aws_secretsmanager_secret_version" "DBSecret" {
    secret_id = var.SecretArn
}

locals {
    EngineMap = {
        "5.6.mysql-aurora.1.19.1": {
            Engine = "aurora",
            EngineVersion = "5.6.mysql_aurora.1.19.1",
            Port = 3306,
            ClusterParameterGroupFamily = "aurora5.6",
            ParameterGroupFamily = "aurora5.6"
        },
        "5.6.mysql-aurora.1.23.2": {
            Engine = "aurora",
            EngineVersion = "5.6.mysql_aurora.1.23.2",
            Port = 3306,
            ClusterParameterGroupFamily = "aurora5.6",
            ParameterGroupFamily = "aurora5.6"
        },
        "5.7.mysql-aurora.2.09.2": {
            Engine = "aurora-mysql",
            EngineVersion = "5.7.mysql_aurora.2.09.2",
            Port = 3306,
            ClusterParameterGroupFamily = "aurora-mysql5.7",
            ParameterGroupFamily = "aurora-mysql5.7"
        },
        "5.7.mysql-aurora.2.03.4": {
            Engine = "aurora-mysql",
            EngineVersion = "5.7.mysql_aurora.2.03.4",
            Port = 3306,
            ClusterParameterGroupFamily = "aurora-mysql5.7",
            ParameterGroupFamily = "aurora-mysql5.7"
        },
        "5.7.mysql-aurora.2.04.3": {
            Engine = "aurora-mysql",
            EngineVersion = "5.7.mysql_aurora.2.04.3",
            Port = 3306,
            ClusterParameterGroupFamily = "aurora-mysql5.7",
            ParameterGroupFamily = "aurora-mysql5.7"
        },
        "aurora-postgresql-10.11": {
            Engine = "aurora-postgresql",
            EngineVersion = "10.11",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql10",
            ParameterGroupFamily = "aurora-postgresql10"
        },
        "aurora-postgresql-10.12": {
            Engine = "aurora-postgresql",
            EngineVersion = "10.12",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql10",
            ParameterGroupFamily = "aurora-postgresql10"
        },
        "aurora-postgresql-10.13": {
            Engine = "aurora-postgresql",
            EngineVersion = "10.13",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql10",
            ParameterGroupFamily = "aurora-postgresql10"
        },
        "aurora-postgresql-10.14": {
            Engine = "aurora-postgresql",
            EngineVersion = "10.14",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql10",
            ParameterGroupFamily = "aurora-postgresql10"
        },
        "aurora-postgresql-10.16": {
            Engine = "aurora-postgresql",
            EngineVersion = "10.16",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql10",
            ParameterGroupFamily = "aurora-postgresql10"
        },
        "aurora-postgresql-11.6": {
            Engine = "aurora-postgresql",
            EngineVersion = "11.6",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql11",
            ParameterGroupFamily = "aurora-postgresql11"
        },
        "aurora-postgresql-11.7": {
            Engine = "aurora-postgresql",
            EngineVersion = "11.7",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql11",
            ParameterGroupFamily = "aurora-postgresql11"
        },
        "aurora-postgresql-11.8": {
            Engine = "aurora-postgresql",
            EngineVersion = "11.8",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql11",
            ParameterGroupFamily = "aurora-postgresql11"
        },
        "aurora-postgresql-11.9": {
            Engine = "aurora-postgresql",
            EngineVersion = "11.9",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql11",
            ParameterGroupFamily = "aurora-postgresql11"
        },
        "aurora-postgresql-11.11": {
            Engine = "aurora-postgresql",
            EngineVersion = "11.11",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql11",
            ParameterGroupFamily = "aurora-postgresql11"
        },
        "aurora-postgresql-12.4": {
            Engine = "aurora-postgresql",
            EngineVersion = "12.4",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql12",
            ParameterGroupFamily = "aurora-postgresql12"
        },
        "aurora-postgresql-12.6": {
            Engine = "aurora-postgresql",
            EngineVersion = "12.6",
            Port = 5432,
            ClusterParameterGroupFamily = "aurora-postgresql12",
            ParameterGroupFamily = "aurora-postgresql12"
        }
    }

    EngineParameters = local.EngineMap[var.Engine]

    ParameterGroupParameters = (
        local.EngineParameters["Engine"] == "aurora" || local.EngineParameters["Engine"] == "aurora-mysql"
    ) ? [
            {
                name = "character_set_client" 
                value = "utf8"
            },
            {
                name = "character_set_connection"
                value = "utf8"
            },
            {
                name = "character_set_database"
                value = "utf8"
            },
            {
                name = "character_set_filesystem"
                value = "utf8"
            },
            {
                name = "character_set_results"
                value = "utf8"
            },
            {
                name = "character_set_server"
                value = "utf8"
            },
            {
                name = "collation_connection"
                value = "utf8_general_ci"
            },
            {
                name = "collation_server"
                value = "utf8_general_ci"
            }
        ] : [
                {
                    name = "client_encoding"
                    value = "UTF8"
                }
            ]
}

resource "aws_iam_role" "MonitoringRole" {
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = "sts:AssumeRole"
                Principal = {
                    Service = "monitoring.rds.amazonaws.com"
                }
            }
        ]
    })
    managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
}

### SECRET TARGET ATTACHMENT - SECRETS MANAGER ATTACHED TO DB CLUSTER

resource "aws_security_group" "ClusterSecurityGroup" {
    description = "Terraform-managed clusterSecurityGroup."
    vpc_id = var.VpcId
    egress = [
        {
            protocol = "-1"
            from_port = 0
            to_port = 0
            cidr_blocks = ["10.0.0.0/8"]
            description = "All internal"

            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ]

    tags = {
        Name = "ClusterSecurityGroup"
    }
}

resource "aws_db_subnet_group" "DBSubnetGroup" {
    description = "Terraform-managed DBSubnetGroup."
    subnet_ids = var.SubnetIds

    tags = {
        Name = "DBSubnetGroup"
    }
}

resource "aws_rds_cluster_parameter_group" "DBClusterParameterGroup" {
    description = "Terraform-managed DBClusterParameterGroup."
    family = local.EngineParameters["ClusterParameterGroupFamily"]
    
    dynamic "parameter" {
        for_each = toset(local.ParameterGroupParameters)

        content {
            name = parameter.value.name
            value = parameter.value.value
        }
    }

    tags = {
        Name = "DBClusterParameterGroup"
    }
}

resource "aws_db_parameter_group" "DBParameterGroup" {
    description = "Terraform-managed DBParameterGroup."
    family = local.EngineParameters["ClusterParameterGroupFamily"]

    tags = {
        Name = "DBParameterGroup"
    }
}

resource "aws_rds_cluster" "DBCluster" {
    backup_retention_period = var.DBBackupRetentionPeriod
    database_name = var.DBName
    db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.DBClusterParameterGroup.name
    db_subnet_group_name = aws_db_subnet_group.DBSubnetGroup.name
    engine = local.EngineParameters["Engine"]
    engine_mode = "provisioned"
    engine_version = local.EngineParameters["EngineVersion"]
    kms_key_id = var.KmsArn
    master_username = jsondecode(data.aws_secretsmanager_secret_version.DBSecret.secret_string)["username"]
    master_password = jsondecode(data.aws_secretsmanager_secret_version.DBSecret.secret_string)["password"]
    port = local.EngineParameters["Port"]
    preferred_backup_window = var.PreferredBackupWindow
    preferred_maintenance_window = var.PreferredMaintenanceWindow
    storage_encrypted = true
    vpc_security_group_ids = [aws_security_group.ClusterSecurityGroup.id]
    deletion_protection = true
    enabled_cloudwatch_logs_exports = ["postgresql"]

    skip_final_snapshot = false
    final_snapshot_identifier = "${var.DBName}-FinalSnapshot"

    tags = {
        Name = "Terraform-managed DBCluster"
    }
}

resource "aws_rds_cluster_instance" "DBInstance" {
    count = var.NumberOfInstances
    
    auto_minor_version_upgrade = true
    copy_tags_to_snapshot = true
    cluster_identifier = aws_rds_cluster.DBCluster.id
    instance_class = var.DBInstanceClass
    db_parameter_group_name = aws_db_parameter_group.DBParameterGroup.name
    db_subnet_group_name = aws_db_subnet_group.DBSubnetGroup.name
    engine = local.EngineParameters["Engine"]
    publicly_accessible = false
    performance_insights_enabled = true
    performance_insights_kms_key_id = var.KmsArn
    monitoring_interval = 60
    monitoring_role_arn = aws_iam_role.MonitoringRole.arn

    tags = {
        Name = "DBInstance${count.index}"
    }
}