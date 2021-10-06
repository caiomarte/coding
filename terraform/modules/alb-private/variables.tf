variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "CertificateArn" {
    description = "ACM ARN to use for HTTPS listener."
    type = string

    validation {
        condition = can(regex("^arn:(aws[a-zA-Z-]*)?:acm:[a-z0-9-]+:\\d{12}:certificate\\/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.CertificateArn))
        error_message = "Must be a valid Certificate ARN. Certificate ARN example: arn:aws:acm:sa-east-1:111122223333:certificate/1234abcd-12ab-34cd-56ef-1234567890ab."
    }
}

variable "VPCID" {
    type = string
}

variable "Subnets" {
    type = list(string)
}

variable "Scheme" {
    description = "ALB scheme."
    type = string

    validation {
        condition = contains(["internet-facing", "internal"], var.Scheme)
        error_message = "Must be a valid ALB scheme - (internet-facing, internal)."
    }
}

variable "SslPolicy" {
    description = "ALB SSL policy. Reference: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html."
    type = string
    default = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

    validation {
        condition = contains([
            "ELBSecurityPolicy-2016-08",
            "ELBSecurityPolicy-TLS-1-0-2015-04",
            "ELBSecurityPolicy-TLS-1-1-2017-01",
            "ELBSecurityPolicy-TLS-1-2-2017-01",
            "ELBSecurityPolicy-TLS-1-2-Ext-2018-06",
            "ELBSecurityPolicy-FS-2018-06",
            "ELBSecurityPolicy-FS-1-1-2019-08",
            "ELBSecurityPolicy-FS-1-2-2019-08",
            "ELBSecurityPolicy-FS-1-2-Res-2019-08",
            "ELBSecurityPolicy-2015-05",
            "ELBSecurityPolicy-FS-1-2-Res-2020-10"
        ], var.SslPolicy)
        error_message = "Must be a valid SSL policy."
    }
}

variable "AccessLogsBucketName" {
    description = "Bucket name where will write ALB access logs."
    type = string
}

variable "AccessLogsBucketPrefix" {
    description = "Bucket prefix. It is mandatory."
    type = string
}