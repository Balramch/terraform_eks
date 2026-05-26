aws_region   = "eu-central-1"
project_name = "mycompany"
environment  = "dev"

cluster_version = "1.31"
vpc_cidr        = "10.10.0.0/16"
az_count        = 2

single_nat_gateway   = true
enable_vpc_flow_logs = false

cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

cluster_enabled_log_types = ["api", "audit"]

managed_node_groups = {
  general = {
    instance_types = ["t3.medium"]
    min_size       = 1
    max_size       = 4
    desired_size   = 2
    labels = {
      role = "general"
    }
  }
}

common_tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}
