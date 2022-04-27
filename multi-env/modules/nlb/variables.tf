variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "VPCID" {
    type = string
}

variable "Subnets" {
    type = list(string)
}

variable "Scheme" {
    type = string

    validation {
        condition = contains([
            "internet-facing",
            "internal"
        ], var.Scheme)
        error_message = "Must be a valid ALB scheme - Internet-facing or internal."
    }
}

variable "AccessLogsBucketName" {
    description = "Bucket name where will write ALB access logs"
    type = string
}

 variable  "AccessLogsBucketPrefix" {
    description = "Bucket prefix. It is mandatory."
    type = string
 }

 variable "CrossZone" {
    description = "Indicates whether cross-zone load balancing is enabled."
    type = bool 
    default = false 
 }

 variable "ListenPort" {
    description = "Load Balancer Listen port"
    type = number
 }

 variable "TargetPort" {
    description ="Load Balancer Target port"
    type = number
 }

variable "TargetType" {
    description = "The type of target that you must specify when registering targets with this target group."
    type = string
    default = "instance"

    validation {
        condition = contains([
            "ip",
            "instance"
        ],var.TargetType)
        error_message ="Must be a valid Network Load Balancer target type."
    }
}