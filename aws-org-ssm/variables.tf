variable "admin" {
  description = "If true, enables cross-account SSM administration. If false, enables an account to be administrated by another. Defaults to false."
  type = bool
  default = false
}

variable "admin_account_id" {
  description = "The ID of the AWS Organizations admin account."
  type = number
}

variable "managed_accounts_ids" {
  description = "The ID of all managed AWS Accounts in the Organization. Required if admin is true."
  type = list(string) 
  default = []
}

variable "target_node_groups" {
  description = "Single string, comma-separated EKS Node Groups to target. Must match managed_accounts_ids order. Supports only one input per managed_accounts_ids element."
  type = list(string) 
  default = []
}

variable "target_clusters" {
  description = "Single string, comma-separated EKS Clusters to target. Must match managed_accounts_ids order. Supports only one input per managed_accounts_ids element."
  type = list(string) 
  default = []
}

variable "target_regions" {
  description = "Single string, comma-separated AWS Regions to target."
  type = list(string) 
  default = ["us-east-2"]
}

variable "maximum_concurrency" {
  description = "The number of instances to update at the same time. Defaults to 1."
  type = number
  default = 1
}

variable "maximum_errors" {
  description = "The number of errors to tolerate before stoping execution. Defaults to 1."
  type = number
  default = 1
}

variable "ssm_admins" {
  description = "The IAM Users that will hold admin permissions for cross-account SSM management. Required if admin is true."
  type = list(string) 
  default = []
}