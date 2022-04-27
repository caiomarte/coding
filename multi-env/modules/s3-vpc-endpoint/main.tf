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

data "aws_region" "AWSRegion" {}

resource "aws_vpc_endpoint" "S3VPCEndpoint" {
    vpc_id = var.VPCID
    service_name = "com.amazonaws.${data.aws_region.AWSRegion.name}.s3"
    route_table_ids = var.RouteTables

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = "*"
                Action = "*"
                Resource = [
                    "*"
                ]
            }
        ]
    })
}