locals {
  eks_managed_node_groups = {
    for name, ng in var.managed_node_groups : name => merge(
      {
        name           = name
        instance_types = ng.instance_types
        capacity_type  = ng.capacity_type
        min_size       = ng.min_size
        max_size       = ng.max_size
        desired_size   = ng.desired_size
        labels         = ng.labels
        taints         = ng.taints

        metadata_options = {
          http_endpoint               = "enabled"
          http_tokens                 = "required"
          http_put_response_hop_limit = 2
        }

        update_config = {
          max_unavailable_percentage = 33
        }

        tags = merge(var.tags, {
          NodeGroup = name
        })
      }
    )
  }

  # Use resolve_conflicts_on_* (resolve_conflicts is deprecated in AWS provider 5.x).
  addon_defaults = {
    most_recent                 = true
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
  }

  cluster_addons = merge(
    {
      vpc-cni = local.addon_defaults
      coredns = local.addon_defaults
      kube-proxy = local.addon_defaults
    },
    var.enable_ebs_csi_driver ? {
      aws-ebs-csi-driver = merge(local.addon_defaults, {
        service_account_role_arn = module.ebs_csi_irsa[0].iam_role_arn
      })
    } : {}
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin

  cluster_enabled_log_types = var.cluster_enabled_log_types

  cluster_encryption_config = {
    provider_key_arn = local.cluster_encryption_key_arn
    resources        = ["secrets"]
  }

  cluster_addons = local.cluster_addons

  eks_managed_node_groups = local.eks_managed_node_groups

  tags = var.tags
}
