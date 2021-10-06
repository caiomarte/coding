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

variable "cluster_name" {
    type = string
}

variable "kafka_version" {
    type = string
}

variable "number_of_broker_nodes" {
    type = number
}

variable "instance_type" {
    type = string
}

variable "ebs_volume_size" {
    type = number
}

variable "kms_arn" {
    type = string
}