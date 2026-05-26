module "vpc" {
  source = "../../modules/vpc"

  name               = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  azs                = local.azs
  single_nat_gateway = var.single_nat_gateway
  enable_flow_logs   = var.enable_vpc_flow_logs
  cluster_name       = local.cluster_name

  tags = var.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_enabled_log_types              = var.cluster_enabled_log_types
  enable_cluster_creator_admin         = var.enable_cluster_creator_admin

  managed_node_groups = var.managed_node_groups

  tags = var.common_tags
}
