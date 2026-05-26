# Kubernetes add-ons (post-Terraform)

Install these **after** the EKS cluster exists. Each typically requires IRSA and Helm.

| Add-on | Purpose | Suggested install |
|--------|---------|-------------------|
| AWS Load Balancer Controller | Ingress → ALB/NLB | Helm + IRSA |
| metrics-server | HPA / kubectl top | Helm or manifest |
| Cluster Autoscaler | ASG scaling from pending pods | Helm + IRSA |
| Karpenter | Node provisioning (alternative to CA) | Helm + IRSA |
| external-dns | Route53 records from Ingress | Helm + IRSA |
| cert-manager | TLS certificates | Helm |

Use the `cluster_oidc_issuer_url` and `oidc_provider_arn` outputs from Terraform when creating IRSA roles.

Example kubeconfig:

```bash
./scripts/setup-kubectl.sh dev
```
