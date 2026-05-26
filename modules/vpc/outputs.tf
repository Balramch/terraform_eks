output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "Private subnet IDs for EKS nodes and control plane."
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs for internet-facing load balancers."
  value       = module.vpc.public_subnets
}

output "intra_subnets" {
  description = "Intra subnets (no NAT) for internal-only resources."
  value       = module.vpc.intra_subnets
}

output "database_subnets" {
  description = "Database subnet IDs (isolated)."
  value       = module.vpc.database_subnets
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs."
  value       = module.vpc.natgw_ids
}

output "private_route_table_ids" {
  description = "Private route table IDs."
  value       = module.vpc.private_route_table_ids
}
