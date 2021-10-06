variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "vpc_id" {
    type = string
}

variable "vpc_cidr_blocks" {
    type = string
}

variable "subnet_az1" {
    type = string
}

variable "subnet_az2" {
    type = string
}

variable "domain_name" {
    type = string
}

variable "elasticsearch_version" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "instance_count" {
    type = number
}

variable "zone_awareness_enabled" {
    type = bool
}

variable "dedicated_master_enabled" {
    type = bool
}

variable "dedicated_master_type" {
    type = string
}

variable "dedicated_master_count" {
    type = number
}

variable "kms_arn" {
    type = string
}

variable "secret_name" {
    type = string
}

variable "volume_size" {
    type = number
}

variable "volume_type" {
    type = string
}