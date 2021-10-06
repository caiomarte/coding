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

data "aws_caller_identity" "AWSAccount" {}

data "aws_region" "AWSRegion" {}

data "aws_iam_policy_document" "LoggingBucketPolicy" {
    statement {
        sid = "LoggingBucketPermissions"
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["delivery.logs.amazonaws.com"]
        }
        actions = [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:GetObjectAcl"
        ]
        resources = [
            "${aws_s3_bucket.LoggingBucket.arn}/AWSLogs/${data.aws_caller_identity.AWSAccount.account_id}/*"
        ]
    }
}

resource "aws_s3_bucket" "LoggingBucket" {
    bucket = "terraform-managed-logging-${data.aws_caller_identity.AWSAccount.account_id}-${data.aws_region.AWSRegion.name}"
    server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
              kms_master_key_id = var.KMSId
              sse_algorithm = "aws:kms"
          }
      }
    }
    versioning {
        enabled = var.LoggingBucketVersioning == "Enabled" ? true : false
    }
}

resource "aws_s3_bucket_policy" "LoggingBucketPolicy" {
    bucket = aws_s3_bucket.LoggingBucket.id
    policy = data.aws_iam_policy_document.LoggingBucketPolicy.json
}

resource "aws_cloudfront_distribution" "CloudFrontDistribution" {
    comment = "Cloudfront Distribution pointing ALB Origin"
    origin {
        domain_name = var.OriginDNS
        origin_id = var.OriginDNS
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = var.OriginProtocolPolicy
            origin_keepalive_timeout = var.OriginKeepaliveTimeout
            origin_read_timeout = var.OriginReadTimeout
            origin_ssl_protocols = [
                "TLSv1",
                "TLSv1.1",
                "TLSv1.2",
                "SSLv3"
            ]
        }
    }
    enabled = true
    http_version = "http2"
    aliases = var.AlternateDomainNames != "" ? [
        var.AlternateDomainNames
    ] : []
    default_cache_behavior {
        allowed_methods = [
            "GET",
            "HEAD",
            "DELETE",
            "OPTIONS",
            "PATCH",
            "POST",
            "PUT"
        ]
        cached_methods = [
            "GET",
            "HEAD"
        ]
        compress = var.Compress
        default_ttl = var.DefaultTTL
        max_ttl = var.MaxTTL
        min_ttl = var.MinTTL
        target_origin_id = var.OriginDNS
        forwarded_values {
            query_string = var.QueryString
            cookies {
                forward = var.ForwardCookies
            }
        }
        viewer_protocol_policy = var.ViewerProtocolPolicy
    }
    price_class = var.PriceClass
    viewer_certificate {
        acm_certificate_arn = var.ACMCertificateIdentifier
        ssl_support_method = var.SslSupportMethod
        minimum_protocol_version = var.MinimumProtocolVersion
    }
    is_ipv6_enabled = var.IPV6Enabled
    

    logging_config {
        bucket = aws_s3_bucket.LoggingBucket.bucket_domain_name
    }restrictions {
        geo_restriction {
            restriction_type = "none" 
        }
    }
}

resource "aws_wafv2_web_acl_association" "WebACLAssociation" {
    count = var.WebACLArn == "" ? 0 : 1

    web_acl_arn = var.WebACLArn
    resource_arn = aws_cloudfront_distribution.CloudFrontDistribution.arn
}