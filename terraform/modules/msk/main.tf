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

resource "aws_security_group" "sg" {
    vpc_id = var.vpc_id
    ingress = [
        {
        description      = "Rule for port 2181"
        from_port        = 2181
        to_port          = 2181
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr_blocks]
        security_groups  = null
        ipv6_cidr_blocks = null
        prefix_list_ids  = null
        self             = null
        },
        {
        description      = "Rule for port 9094"
        from_port        = 9094
        to_port          = 9094
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr_blocks]
        security_groups  = null        
        ipv6_cidr_blocks = null
        prefix_list_ids  = null
        self             = null
        },      
        {
        description      = "Rule for port 9094"
        from_port        = 9092
        to_port          = 9092
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr_blocks]
        security_groups  = null        
        ipv6_cidr_blocks = null
        prefix_list_ids  = null
        self             = null
        }         
    ]

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

resource "aws_msk_cluster" "msk" {
    cluster_name = var.cluster_name
    kafka_version = var.kafka_version
    number_of_broker_nodes = var.number_of_broker_nodes

    broker_node_group_info {
        instance_type = var.instance_type
        ebs_volume_size = var.ebs_volume_size
        client_subnets = [
             var.subnet_az1
            ,var.subnet_az2
            ,var.subnet_az3
        ]
        security_groups = [aws_security_group.sg.id]
    }
    encryption_info {
        encryption_at_rest_kms_key_arn = var.kms_arn
    }
    open_monitoring {
        prometheus {
            jmx_exporter {
                enabled_in_broker = true
            }
            node_exporter {
                enabled_in_broker = true
            }
        }
    }    
    client_authentication {
        sasl {     
            iam = true 
        }
    }                 
}