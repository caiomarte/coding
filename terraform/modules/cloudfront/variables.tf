variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "AlternateDomainNames" {
    description = "CNAMEs (alternate domain names), if any, for the distribution. Example. mydomain.com."
    type = string
    default = "name.domain.com"
}

variable "ACMCertificateIdentifier" {
    description = "The AWS Certificate Manager (ACM) certificate identifier."
    type = string
    default = ""
}

variable "KMSId" {
    description = "The AWS KMS Key ID used in the S3 Logging Bucket."
    type = string
    default = ""
}

variable "OriginDNS" {
    description = "Origin DNS (ELB)."
    type = string
    default = ""
}

variable "WebACLArn" {
    description = "Web ACL ARN to use for CloudFront."
    type = string
    default = ""

    validation {
        condition = can(regex("^$|^arn:(aws[a-zA-Z-]*)?:wafv2:[a-z0-9-]+:\\d{12}:(regional|global)\\/webacl\\/[A-Za-z0-9-_]+\\/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.WebACLArn))
        error_message = "Key ARN example: arn:aws:wafv2:sa-east-1:870890345262:regional/webacl/teste/1234abcd-12ab-34cd-56ef-1234567890ab."
    }
}

variable "IPV6Enabled" {
    description = "Should CloudFront to respond to IPv6 DNS requests with an IPv6 address for your distribution."
    type = bool
    default = true
}

variable "OriginProtocolPolicy" {
    description = "CloudFront Origin Protocol Policy to apply to your origin."
    type = string
    default = "http-only"

    validation {
        condition = contains([
            "http-only",
            "match-viewer",
            "https-only"
        ], var.OriginProtocolPolicy)
        error_message = "Must be either http-only, match-viewer, or https-only."
    }
}

variable "Compress" {
    description = "CloudFront Origin Protocol Policy to apply to your origin."
    type = bool
    default = false
}

variable "DefaultTTL" {
    description = "The default time in seconds that objects stay in CloudFront caches before CloudFront forwards another request to your custom origin. By default, it is set to 86400 seconds (one day)."
    type = number
    default = 86400
}

variable "MaxTTL" {
    description = "The maximum time in seconds that objects stay in CloudFront caches before CloudFront forwards another request to your custom origin. By default, it is set to 31536000 seconds (one year)."
    type = number
    default = 31536000
}

variable "MinTTL" {
    description = "The minimum amount of time that you want objects to stay in the cache before CloudFront queries your origin to see whether the object has been updated."
    type = number
    default = 0
}

variable "QueryString" {
    description = "Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior."
    type = bool
    default = true
}

variable "ForwardCookies" {
    description = "Forwards specified cookies to the origin of the cache behavior."
    type = string
    default = "all"

    validation {
        condition = contains([
            "all",
            "whitelist",
            "none"
        ], var.ForwardCookies)
        error_message = "Must be either all, whitelist, or none."
    }
}

variable "ViewerProtocolPolicy" {
    description = "The protocol that users can use to access the files in the origin that you specified in the TargetOriginId property when the default cache behavior is applied to a request."
    type = string
    default = "redirect-to-https"

    validation {
        condition = contains([
            "redirect-to-https",
            "allow-all",
            "https-only"
        ], var.ViewerProtocolPolicy)
        error_message = "Must be either redirect-to-https, allow-all, or https-only."
    }
}

variable "PriceClass" {
    description = "The price class that corresponds with the maximum price that you want to pay for CloudFront service. If you specify PriceClass_All, CloudFront responds to requests for your objects from all CloudFront edge locations."
    type = string
    default = "PriceClass_All"

    validation {
        condition = contains([
            "PriceClass_All",
            "PriceClass_100",
            "PriceClass_200"
        ], var.PriceClass)
        error_message = "Must be either PriceClass_All, PriceClass_100, or PriceClass_200."
    }
}

variable "SslSupportMethod" {
    description = "Specifies how CloudFront serves HTTPS requests."
    type = string
    default = "sni-only"

    validation {
        condition = contains([
            "sni-only",
            "vip"
        ], var.SslSupportMethod)
        error_message = "Must be either sni-only or vip."
    }
}

variable "MinimumProtocolVersion" {
    description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
    type = string
    default = "TLSv1"

    validation {
        condition = contains([
            "SSLv3",
            "TLSv1",
            "TLSv1.1_2016",
            "TLSv1.2_2018",
            "TLSv1.2_2019",
            "TLSv1.2_2021",
            "TLSv1_2016"
        ], var.MinimumProtocolVersion)
        error_message = "Must be a valid SSL protocol version."
    }
}

variable "OriginKeepaliveTimeout" {
    description = "You can create a custom keep-alive timeout. All timeout units are in seconds. The default keep-alive timeout is 5 seconds, but you can configure custom timeout lengths. The minimum timeout length is 1 second; the maximum is 60 seconds."
    type = number
    default = 5

    validation {
        condition = var.OriginKeepaliveTimeout >= 1 && var.OriginKeepaliveTimeout <= 30
        error_message = "Minimum: 1, Maximum: 30."
    }
}

variable "OriginReadTimeout" {
    description = "You can create a custom origin read timeout. All timeout units are in seconds. The default origin read timeout is 30 seconds, but you can configure custom timeout lengths. The minimum timeout length is 4 seconds; the maximum is 60 seconds."
    type = number
    default = 30

    validation {
        condition = var.OriginReadTimeout >= 4 && var.OriginReadTimeout <= 60
        error_message = "Minimum: 4, Maximum: 60."
    }
}

variable "LoggingBucketVersioning" {
    description = "The versioning state of an Amazon S3 bucket. If you enable versioning, you must suspend versioning to disable it."
    type = string
    default = "Suspended"

    validation {
        condition = contains(["Enabled", "Suspended"], var.LoggingBucketVersioning)
        error_message = "Must be either Enabled or Suspended."
    }
}