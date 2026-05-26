variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "prod"
}

variable "cluster_name" {
  description = "Override EKS cluster name."
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes version."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
}

variable "az_count" {
  description = "Number of AZs (2-3)."
  type        = number

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "az_count must be between 2 and 3."
  }
}

variable "single_nat_gateway" {
  description = "Single NAT gateway for cost savings."
  type        = bool
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC flow logs."
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access" {
  description = "Public Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to access public API."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_enabled_log_types" {
  description = "EKS control plane logs."
  type        = list(string)
}

variable "enable_cluster_creator_admin" {
  description = "Admin access for Terraform caller."
  type        = bool
  default     = true
}

variable "managed_node_groups" {
  description = "EKS managed node groups."
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

variable "common_tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
