locals {
  az_count         = length(var.azs)
  private_subnets  = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets   = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, i + 8)]
  intra_subnets    = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, i + 4)]
  database_subnets = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, i + 12)]

  public_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/${var.cluster_name}"   = "shared"
  })

  private_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/${var.cluster_name}"   = "shared"
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets
  intra_subnets    = local.intra_subnets
  database_subnets = local.database_subnets

  create_database_subnet_group = false

  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log                      = var.enable_flow_logs
  create_flow_log_cloudwatch_log_group   = var.enable_flow_logs
  create_flow_log_cloudwatch_iam_role    = var.enable_flow_logs
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_retention_days

  public_subnet_tags  = local.public_subnet_tags
  private_subnet_tags = local.private_subnet_tags

  tags = var.tags
}
