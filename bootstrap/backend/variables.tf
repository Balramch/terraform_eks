variable "aws_region" {
  description = "AWS region for the state backend."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used in bucket and table naming."
  type        = string
}

variable "state_bucket_name" {
  description = <<-EOT
    Globally unique S3 bucket name for Terraform state.
    Must be 3-63 chars, lowercase letters, numbers, and hyphens only.
    Leave null to auto-generate: {project_name}-tfstate-{account_id}
  EOT
  type        = string
  default     = null

  validation {
    condition = (
      var.state_bucket_name == null ||
      (
        can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.state_bucket_name)) &&
        !strcontains(var.state_bucket_name, "..") &&
        !strcontains(var.state_bucket_name, ".-") &&
        !strcontains(var.state_bucket_name, "-.")
      )
    )
    error_message = "state_bucket_name must be 3-63 characters, lowercase only (a-z, 0-9, hyphens). No uppercase or underscores. Example: mycompany-eks-tfstate-123456789012"
  }
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for backend resources."
  type        = map(string)
  default     = {}
}
