terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}
 
locals {
    scheme = var.Scheme == "internal" ? true : false
}

provider "aws" {
    region = var.AWSRegion
}

resource "aws_lb" "LoadBalancer" {
    ip_address_type = "ipv4"
    load_balancer_type = "network"
    subnets = var.Subnets
    access_logs {
        bucket = var.AccessLogsBucketName
        prefix = var.AccessLogsBucketPrefix
        enabled = true
    }
    enable_deletion_protection = true
    enable_cross_zone_load_balancing = var.CrossZone
    internal = local.scheme
}

resource "aws_lb_listener" "PortListener" {
    load_balancer_arn = aws_lb.LoadBalancer.arn
    port = var.ListenPort
    protocol = "TCP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.TargetGroup.arn
    }
}

resource "aws_lb_target_group" "TargetGroup" {
    health_check {
        enabled = true
        interval = 10   # The supported values are 10 and 30 seconds.
        port = var.TargetPort
        protocol = "TCP"
        healthy_threshold = 2
        unhealthy_threshold = 2 
    }
    port = var.TargetPort
    protocol = "TCP"
    target_type = var.TargetType
    vpc_id = var.VPCID
    deregistration_delay = 300
    stickiness {
        enabled = false
        type = "source_ip"
    }
} 