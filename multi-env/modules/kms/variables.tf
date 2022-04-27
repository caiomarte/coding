variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "AliasName" {
    description = "Key alias name."
    type = string
    default = "AcessoGovBr"
}

variable "AdminRoleArn" {
    description = "ARN of Admin role."
    type = string
}