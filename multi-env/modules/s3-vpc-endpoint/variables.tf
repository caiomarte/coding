variable "AWSRegion" {
    type = string
    description = "AWS Region to deploy resources to"
}

variable "VPCID" {
    type = string
}

variable "RouteTables" {
    type = list(string)
}