variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "VPCID" {
    type = string
}

variable "VpcCIDR" {
    type = string
}

variable "PrivateAppSubnet1" {
    type = string
}

variable "PrivateAppSubnet2" {
    type = string
}

variable "PrivateAppSubnet3" {
    type = string
}

variable "KMSArn" {
    type = string
}

# Msk
variable "MskClusterName" {
    type = string
}

variable "MskKafkaVersion" {
    type = string
}

variable "MskNumberOfNodes" {
    type = number
}

variable "MskInstanceType" {
    type = string
}

variable "MskEBSVolumeSize" {
    type = number
}

# Elasticsearch
variable "EsDomainName" {
    type = string
}

variable "EsElasticsearchVersion" {
    type = string
}

variable "EsInstanceType" {
    type = string
}

variable "EsInstanceCount" {
    type = number
}

variable "EsZoneAwarenessEnabled" {
    type = bool
}

variable "EsDedicatedMasterEnabled" {
    type = bool
}

variable "EsDedicatedMasterType" {
    type = string
}

variable "EsDedicatedMasterCount" {
    type = number
}

variable "EsSecretName" {
    type = string
}

variable "EsVolumeSize" {
    type = number
}

variable "EsVolumeType" {
    type = string
}

# Efs
variable "EfsFileSystemName" {
    type = string
}

variable "EfsPerformanceMode" {
    type = string
}

variable "EfsThroughputMode" {
    type = string
}

variable "EfsFileSharePort" {
    type = number
}

variable "EfsProvisionedThroughputInMibps" {
    type = number
}