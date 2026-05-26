# Architecture

## High-level design

This repository uses a **multi-environment, multi-module** layout:

- **`modules/`** — Reusable building blocks (VPC, EKS). No remote state; consumed by environments.
- **`environments/`** — One Terraform root per environment (`dev`, `staging`, `prod`). Each has isolated state.
- **`bootstrap/`** — One-time (per account/region) S3 + DynamoDB for remote state.

## Network topology

```
                         Internet
                             |
                    Internet Gateway
                             |
              +------------+------------+
              |     Public subnets      |
              |  (ALB/NLB, NAT Gateway) |
              +------------+------------+
                             |
                      NAT Gateway(s)
                             |
              +------------+------------+
              |    Private subnets      |
              | EKS control plane ENIs  |
              | Managed node groups     |
              +------------+------------+
                             |
                    EKS API (AWS managed)

              +------------+------------+
              |   Intra / DB subnets    |
              | (future RDS, internal)  |
              +-------------------------+
```

## Security controls (production module defaults)

| Control | Implementation |
|---------|----------------|
| Secrets encryption | KMS key + `cluster_encryption_config` |
| API access restriction | `cluster_endpoint_public_access_cidrs` |
| IMDSv2 | `http_tokens = required` on nodes |
| Audit logging | CloudWatch log types on control plane |
| Least-privilege storage | EBS CSI via IRSA (not node policy) |
| State protection | S3 versioning, encryption, DynamoDB lock |

## State partitioning

| State file key | Stack |
|----------------|--------|
| N/A (local or separate bootstrap state) | `bootstrap/backend` |
| `eks/dev/terraform.tfstate` | `environments/dev` |
| `eks/staging/terraform.tfstate` | `environments/staging` |
| `eks/prod/terraform.tfstate` | `environments/prod` |

## Extension points

Post-cluster components (not in Terraform here; add under `kubernetes/`):

- AWS Load Balancer Controller (Ingress)
- Cluster Autoscaler or Karpenter
- External DNS, cert-manager
- Observability (ADOT, Prometheus, Grafana)
