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

resource "aws_security_group" "LoadBalancerSecurityGroup" {
    description = "Terraform-managed LoadBalancerSecurityGroup."
    vpc_id = var.VPCID
    ingress = var.Scheme == "internet-facing" ? [
        {
            protocol = "tcp"
            from_port = 80
            to_port = 80
            cidr_blocks = ["0.0.0.0/0"]
            description = "From Internet"

            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        },
        {
            protocol = "tcp"
            from_port = 443
            to_port = 443
            cidr_blocks = ["0.0.0.0/0"]
            description = "From Internet"

            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ] : []
    egress = var.Scheme == "internet-facing" ? [
        {
            protocol = "-1"
            from_port = 0
            to_port = 0
            cidr_blocks = ["0.0.0.0/0"]
            description = "All"

            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ] : [
            {
                protocol = "-1"
                from_port = 0
                to_port = 0
                cidr_blocks = ["0.0.0.0/0"]
                description = "All internal"

                ipv6_cidr_blocks = []
                prefix_list_ids = []
                security_groups = []
                self = false
            }
        ]
        
    tags = {
        Name = "LoadBalancerSecurityGroup"
    }
}

resource "aws_lb" "LoadBalancer" {
    internal = var.Scheme == "internal" ? true : false
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    access_logs {
        enabled = true
        bucket = var.AccessLogsBucketName
        prefix = var.AccessLogsBucketPrefix
    }
    enable_deletion_protection = true
    idle_timeout = 60
    drop_invalid_header_fields = false
    subnets = var.Subnets
    security_groups = [aws_security_group.LoadBalancerSecurityGroup.id]
}

resource "aws_lb_listener" "Port80Listener" {
    load_balancer_arn = aws_lb.LoadBalancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "redirect"
        redirect {
            protocol = "HTTPS"
            port = 443
            host = "#{host}"
            path = "/#{path}"
            query = "#{query}"
            status_code = "HTTP_301"    # 301 Moved Permanently
        }
    }
}

resource "aws_lb_listener" "Port443Listener" {
    load_balancer_arn = aws_lb.LoadBalancer.arn
    port = 443
    protocol = "HTTPS"
    certificate_arn = var.CertificateArn
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Invalid listener rule"
            status_code = "404"
        }
    }
    ssl_policy = var.SslPolicy
}

resource "aws_lb_listener_certificate" "Port443ListenerCertificate" {
    certificate_arn = var.CertificateArn
    listener_arn = aws_lb_listener.Port443Listener.arn
}