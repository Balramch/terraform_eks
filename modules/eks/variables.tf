variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes control plane version."
  type        = string
  default     = "1.32"
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for nodes and control plane."
  type        = list(string)
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable private API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_cluster_creator_admin" {
  description = "Grant cluster-admin to the Terraform IAM principal."
  type        = bool
  default     = true
}

variable "cluster_enabled_log_types" {
  description = "EKS control plane log types sent to CloudWatch."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_encryption_kms_key_arn" {
  description = "KMS key ARN for secrets encryption. Null creates a new key."
  type        = string
  default     = null
}

variable "create_kms_key" {
  description = "Create a dedicated KMS key for cluster secrets encryption."
  type        = bool
  default     = true
}

variable "managed_node_groups" {
  description = "EKS managed node group definitions."
  type = map(object({
    instance_types = list(string)
    capacity_type  = optional(string, "ON_DEMAND")
    min_size       = number
    max_size       = number
    desired_size   = number
    labels         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = optional(string)
      effect = string
    })), [])
  }))
}

variable "enable_ebs_csi_driver" {
  description = "Install aws-ebs-csi-driver add-on with IRSA."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to EKS resources."
  type        = map(string)
  default     = {}
}
