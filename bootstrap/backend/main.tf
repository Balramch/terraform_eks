data "aws_caller_identity" "current" {}

locals {
  table_name  = coalesce(var.dynamodb_table_name, "${var.project_name}-terraform-locks")
  bucket_name = coalesce(
    var.state_bucket_name,
    "${replace(lower(var.project_name), "_", "-")}-tfstate-${data.aws_caller_identity.current.account_id}"
  )
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  tags = merge(var.tags, {
    Name    = local.bucket_name
    Purpose = "terraform-remote-state"
  })
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, {
    Name    = local.table_name
    Purpose = "terraform-state-lock"
  })
}
