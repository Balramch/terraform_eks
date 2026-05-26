locals {
  azs          = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  cluster_name = coalesce(var.cluster_name, "${var.project_name}-${var.environment}-eks")
  name_prefix  = "${var.project_name}-${var.environment}"
}
