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

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret_version" "secret" {
    secret_id = var.secret_name
}

locals {
    creds = jsondecode(
        data.aws_secretsmanager_secret_version.secret.secret_string
    )
}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_security_group" "EC2SecurityGroup" {
    description = "security group for ES Cluster access"
    vpc_id = var.vpc_id
    ingress = [{
        description      = "Rule for port 80"
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks      = [var.vpc_cidr_blocks]
        security_groups  = null
        ipv6_cidr_blocks = null
        prefix_list_ids  = null
        self             = null        
    },
    {
        description      = "Rule for port 443"
        from_port = 443
        protocol = "tcp"
        to_port = 443
        cidr_blocks      = [var.vpc_cidr_blocks]
        security_groups  = null
        ipv6_cidr_blocks = null
        prefix_list_ids  = null
        self             = null               
    }]
    egress = [
        {
        description      = "Egress rules"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        security_groups  = null        
        ipv6_cidr_blocks = null
        prefix_list_ids  = null
        self             = null
        }
    ]
}

resource "aws_elasticsearch_domain" "ElasticsearchDomain" {
    domain_name = "acessogovbr-elasticsearch"
    advanced_security_options {
        enabled = true
        internal_user_database_enabled = true
        master_user_options {
            master_user_name = local.creds.username
            master_user_password = local.creds.password
        }
    }
    elasticsearch_version = "7.10"
    cluster_config {
        dedicated_master_count = var.dedicated_master_count
        dedicated_master_enabled = var.dedicated_master_enabled
        dedicated_master_type = var.dedicated_master_type
        instance_count = var.instance_count
        instance_type = var.instance_type
        zone_awareness_enabled = var.zone_awareness_enabled
    }
    access_policies  = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":\"es:ESHttp*\",\"Resource\":\"arn:aws:es:sa-east-1:${local.account_id}:domain/${var.domain_name}/*\"}]}"
    vpc_options {
        security_group_ids = [
            aws_security_group.EC2SecurityGroup.id
        ]
        subnet_ids = [
             var.subnet_az1
            ,var.subnet_az2
        ]
    }
    encrypt_at_rest {
        enabled = true
        kms_key_id = var.kms_arn
    }

    domain_endpoint_options {
        enforce_https = true
        tls_security_policy  = "Policy-Min-TLS-1-2-2019-07"
    }

    node_to_node_encryption {
        enabled = true
    }
    
    advanced_options = {
        "rest.action.multi.allow_explicit_index" = "true"
    }

    ebs_options {
        ebs_enabled = true
        volume_type = var.volume_type
        volume_size = var.volume_size
        iops = 0
    }
}
