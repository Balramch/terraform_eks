resource "aws_kms_key" "eks" {
  count = var.create_kms_key && var.cluster_encryption_kms_key_arn == null ? 1 : 0

  description             = "EKS secrets encryption for ${var.cluster_name}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-eks-secrets"
  })
}

resource "aws_kms_alias" "eks" {
  count = length(aws_kms_key.eks) > 0 ? 1 : 0

  name          = "alias/${var.cluster_name}-eks-secrets"
  target_key_id = aws_kms_key.eks[0].key_id
}

locals {
  cluster_encryption_key_arn = coalesce(
    var.cluster_encryption_kms_key_arn,
    try(aws_kms_key.eks[0].arn, null)
  )
}

check "cluster_encryption_key" {
  assert {
    condition     = local.cluster_encryption_key_arn != null
    error_message = "EKS secrets encryption requires create_kms_key=true or a valid cluster_encryption_kms_key_arn."
  }
}
