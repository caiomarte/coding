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

locals{
  provisionedThroughputMode = "${var.throughput_mode == "provisioned" ? true : false}"
  subnets = tolist([var.subnet_az1, var.subnet_az2, var.subnet_az3])
}

resource "aws_security_group" "OriginSecurityGroup" {
    vpc_id = var.vpc_id
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

resource "aws_security_group" "MountTargetSecurityGroup" {
    vpc_id = var.vpc_id
    ingress = [
        {
        description      = "Rule for FileSharePort"
        from_port        = var.file_share_port
        to_port          = var.file_share_port
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr_blocks]
        security_groups  = [
            "${aws_security_group.OriginSecurityGroup.id}"
        ]
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

resource "aws_efs_file_system" "FileSystem" {
    performance_mode = var.performance_mode
    encrypted = true
    kms_key_id = var.kms_arn
    throughput_mode = var.throughput_mode
    provisioned_throughput_in_mibps = local.provisionedThroughputMode == true ? var.provisioned_throughput_in_mibps : null

    tags = {
        Name = var.file_system_name
    }    
}

resource "aws_efs_mount_target" "MountTarget" {
    count = length(local.subnets)

    file_system_id = aws_efs_file_system.FileSystem.id
    security_groups = [
        aws_security_group.MountTargetSecurityGroup.id
    ]
    subnet_id = local.subnets[count.index]
}