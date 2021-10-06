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

variable "subnet_az3" {
    type = string
}

variable "file_system_name" {
    type = string
}

variable "performance_mode" {
    type = string
}

variable "throughput_mode" {
    type = string
}

variable "file_share_port" {
    type = number
}

variable "provisioned_throughput_in_mibps" {
    type = number
}

variable "kms_arn" {
    type = string
}