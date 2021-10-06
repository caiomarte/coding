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

data "aws_availability_zones" "AvailabilityZones" {
    state = "available"
}

locals {
    subnets = 3
    azReference = ["A", "B", "C"]
}

resource "aws_vpc" "VPC" {
    cidr_block = var.VpcCIDR
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.TagName
    }
}

resource "aws_internet_gateway" "InternetGateway" {
    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = var.TagName
    }
}

### Public
resource "aws_subnet" "PublicSubnet" {
    count = local.subnets
    
    vpc_id = aws_vpc.VPC.id
    availability_zone = data.aws_availability_zones.AvailabilityZones.names[count.index]
    cidr_block = var.PublicSubnetsCIDRs[count.index]
    map_public_ip_on_launch = false

    tags = {
        Name = "Public1${local.azReference[count.index]}"
    }
}

resource "aws_route_table" "PublicRouteTable" {
    count = local.subnets

    vpc_id = aws_vpc.VPC.id

    route = [
        {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.InternetGateway.id

            carrier_gateway_id = ""
            destination_prefix_list_id = ""
            egress_only_gateway_id = ""
            instance_id = ""
            ipv6_cidr_block = ""
            local_gateway_id = ""
            nat_gateway_id = ""
            network_interface_id = ""
            transit_gateway_id = ""
            vpc_endpoint_id = ""
            vpc_peering_connection_id = ""
        }
    ]

    tags = {
        Name = "Public1${local.azReference[count.index]}"
    }
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation" {
    count = local.subnets

    route_table_id = aws_route_table.PublicRouteTable.*.id[count.index]
    subnet_id = aws_subnet.PublicSubnet.*.id[count.index]
}

resource "aws_network_acl" "PublicNACL" {
    vpc_id = aws_vpc.VPC.id
    subnet_ids = aws_subnet.PublicSubnet.*.id

    ingress = [
        {
            rule_no = 100
            protocol = -1
            action = "allow"
            cidr_block = "0.0.0.0/0"
            
            from_port = 0
            to_port = 0

            icmp_code = 0
            icmp_type = 0
            ipv6_cidr_block = ""
        }
    ]

    egress = [
        {
            rule_no = 100
            protocol = -1
            action = "allow"
            cidr_block = "0.0.0.0/0"
            
            from_port = 0
            to_port = 0

            icmp_code = 0
            icmp_type = 0
            ipv6_cidr_block = ""
        }
    ]

    tags = {
        Name = "Public"
    }
}

### NAT Gateway
resource "aws_eip" "NatGatewayEIP" {
    depends_on = [aws_internet_gateway.InternetGateway]
    count = var.CreateNatOnlyOnOneAZ ? 1 : local.subnets

    vpc = true

    tags = {
        Name = "NatGateway-Public1${local.azReference[count.index]}"
    }
}

resource "aws_nat_gateway" "NatGateway" {
    count = var.CreateNatOnlyOnOneAZ ? 1 : local.subnets
    
    allocation_id = aws_eip.NatGatewayEIP.*.id[count.index]
    subnet_id = aws_subnet.PublicSubnet.*.id[count.index]

    tags = {
        Name = "Public1${local.azReference[count.index]}" 
    }
}

### Private App
resource "aws_subnet" "PrivateAppSubnet" {
    count = local.subnets
    
    vpc_id = aws_vpc.VPC.id
    availability_zone = data.aws_availability_zones.AvailabilityZones.names[count.index]
    cidr_block = var.PrivateAppSubnetsCIDRs[count.index]
    map_public_ip_on_launch = false

    tags = {
        Name = "PrivateApp1${local.azReference[count.index]}"
    }
}

resource "aws_route_table" "PrivateAppRouteTable" {
    count = local.subnets

    vpc_id = aws_vpc.VPC.id

    route = [
        {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = var.CreateNatOnlyOnOneAZ ? aws_nat_gateway.NatGateway.*.id[0] : aws_nat_gateway.NatGateway.*.id[count.index]
        
            carrier_gateway_id = ""
            destination_prefix_list_id = ""
            egress_only_gateway_id = ""
            gateway_id = ""
            instance_id = ""
            ipv6_cidr_block = ""
            local_gateway_id = ""
            network_interface_id = ""
            transit_gateway_id = ""
            vpc_endpoint_id = ""
            vpc_peering_connection_id = ""
        }
    ]

    tags = {
        Name = "Public1${local.azReference[count.index]}"
    }
}

resource "aws_route" "TransitGatewayPrivateAppRoute" {
    depends_on = [aws_ec2_transit_gateway_vpc_attachment.TransitGatewayAttachment]
    count = var.TransitGatewayId != "" ? local.subnets : 0

    route_table_id = aws_route_table.PrivateAppRouteTable.*.id[count.index]
    destination_cidr_block = var.TransitGatewayRouteCIDR
    transit_gateway_id = var.TransitGatewayId
}

resource "aws_route_table_association" "PrivateAppSubnetRouteTableAssociation" {
    count = local.subnets

    route_table_id = aws_route_table.PrivateAppRouteTable.*.id[count.index]
    subnet_id = aws_subnet.PrivateAppSubnet.*.id[count.index]
}

resource "aws_network_acl" "PrivateAppNACL" {
    vpc_id = aws_vpc.VPC.id
    subnet_ids = aws_subnet.PrivateAppSubnet.*.id

    ingress = [
        {
            rule_no = 100
            protocol = -1
            action = "allow"
            cidr_block = "0.0.0.0/0"
            
            from_port = 0
            to_port = 0

            icmp_code = 0
            icmp_type = 0
            ipv6_cidr_block = ""
        }
    ]

    egress = [
        {
            rule_no = 100
            protocol = -1
            action = "allow"
            cidr_block = "0.0.0.0/0"
            
            from_port = 0
            to_port = 0

            icmp_code = 0
            icmp_type = 0
            ipv6_cidr_block = ""
        }
    ]

    tags = {
        Name = "PrivateApp"
    }
}

### Private DB
resource "aws_subnet" "PrivateDBSubnet" {
    count = local.subnets
    
    vpc_id = aws_vpc.VPC.id
    availability_zone = data.aws_availability_zones.AvailabilityZones.names[count.index]
    cidr_block = var.PrivateDBSubnetsCIDRs[count.index]
    map_public_ip_on_launch = false

    tags = {
        Name = "PrivateDB1${local.azReference[count.index]}"
    }
}

resource "aws_route_table" "PrivateDBRouteTable" {
    count = local.subnets

    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = "PrivateDB1${local.azReference[count.index]}"
    }
}

resource "aws_route" "TransitGatewayPrivateDBRoute" {
    depends_on = [aws_ec2_transit_gateway_vpc_attachment.TransitGatewayAttachment]
    count = var.TransitGatewayId != "" ? local.subnets : 0

    route_table_id = aws_route_table.PrivateDBRouteTable.*.id[count.index]
    destination_cidr_block = var.TransitGatewayRouteCIDR
    transit_gateway_id = var.TransitGatewayId
}

resource "aws_route_table_association" "PrivateDBSubnetRouteTableAssociation" {
    count = local.subnets

    route_table_id = aws_route_table.PrivateDBRouteTable.*.id[count.index]
    subnet_id = aws_subnet.PrivateDBSubnet.*.id[count.index]
}

resource "aws_network_acl" "PrivateDBNACL" {
    vpc_id = aws_vpc.VPC.id
    subnet_ids = aws_subnet.PrivateDBSubnet.*.id

    ingress = [
        {
            rule_no = 100
            protocol = -1
            action = "allow"
            cidr_block = "0.0.0.0/0"
            
            from_port = 0
            to_port = 0

            icmp_code = 0
            icmp_type = 0
            ipv6_cidr_block = ""
        }
    ]

    egress = [
        {
            rule_no = 100
            protocol = -1
            action = "allow"
            cidr_block = "0.0.0.0/0"
            
            from_port = 0
            to_port = 0

            icmp_code = 0
            icmp_type = 0
            ipv6_cidr_block = ""
        }
    ]

    tags = {
        Name = "PrivateDB"
    }
}

### VPC Flow Logs
resource "aws_iam_role" "VPCFlowLogsRole" {
    count = var.CreateVPCFlowLogsToCloudWatch ? 1 : 0

    description = "Permissions to Publish VPC Flow Logs to CloudWatch Logs."
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = "sts:AssumeRole"
                Principal = {
                    Service = "vpc-flow-logs.amazonaws.com"
                }
            }
        ]
    })
    path = "/"
    inline_policy {
        name = "CloudWatchLogGroup"
        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Sid = "CloudWatchLogs"
                    Effect = "Allow"
                    Action = [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:DescribeLogGroups",
                        "logs:DescribeLogStreams"
                    ]
                    Resource = aws_cloudwatch_log_group.VPCFlowLogsLogGroup.*.arn[0]
                }
            ]
        })
    }
}

resource "aws_cloudwatch_log_group" "VPCFlowLogsLogGroup" {
    count = var.CreateVPCFlowLogsToCloudWatch ? 1 : 0

    retention_in_days = var.VPCFlowLogsLogGroupRetention
    kms_key_id = var.VPCFlowLogsCloudWatchKMSKey
}

resource "aws_flow_log" "VPCFlowLogsToCloudWatch" {
    count = var.CreateVPCFlowLogsToCloudWatch ? 1 : 0

    log_destination_type = "cloud-watch-logs"
    log_destination = aws_cloudwatch_log_group.VPCFlowLogsLogGroup.*.arn[0]
    iam_role_arn = aws_iam_role.VPCFlowLogsRole.*.arn[0]
    max_aggregation_interval = var.VPCFlowLogsMaxAggregationInterval
    vpc_id = aws_vpc.VPC.id
    traffic_type = var.VPCFlowLogsTrafficType

    tags = {
        Name = "ToCloudWatch"
    }
}

### Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "TransitGatewayAttachment" {
    count = var.TransitGatewayId != "" ? 1 : 0

    subnet_ids = aws_subnet.PrivateAppSubnet.*.id
    transit_gateway_id = var.TransitGatewayId
    vpc_id = aws_vpc.VPC.id

    tags = {
        Name = var.TransitGatewayAttachmentTagName
    }
}