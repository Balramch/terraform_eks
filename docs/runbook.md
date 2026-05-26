# Operations runbook

## Deploy new environment

1. Bootstrap state: `make bootstrap-backend` (once per account/region).
2. Copy `environments/<env>/backend.hcl.example` → `backend.hcl`.
3. Copy `terraform.tfvars.example` → `terraform.tfvars` and customize.
4. `make init ENV=<env>`
5. `make plan ENV=<env>` — review NAT, node counts, API CIDRs.
6. `make apply ENV=<env>` (~15–25 min for EKS).
7. `./scripts/setup-kubectl.sh <env>`
8. `kubectl get nodes` and `kubectl get pods -A`

## Upgrade Kubernetes version

1. Check [EKS version support](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html).
2. Update `cluster_version` in `terraform.tfvars`.
3. `make plan ENV=<env>` — expect control plane then node group updates.
4. Apply during maintenance window for `prod`.
5. Verify add-ons: `aws eks list-addons --cluster-name <name>`

## Scale nodes

Edit `managed_node_groups.*.desired_size` / `min_size` / `max_size` in tfvars, then `make apply ENV=<env>`.

For autoscaling beyond static ASG, deploy Cluster Autoscaler or Karpenter (see `kubernetes/addons/README.md`).

## Rotate / restrict API access

1. Set `cluster_endpoint_public_access_cidrs` to office/VPN CIDRs.
2. `terraform apply`
3. Confirm `kubectl` still works from allowed networks.

## Destroy environment

1. Delete all `LoadBalancer` Services and PVCs.
2. Wait for ELBs and EBS volumes to clear in AWS console.
3. `make destroy ENV=<env>`
4. Do **not** delete bootstrap S3/DynamoDB if other envs use them.

## Incident: nodes NotReady

```bash
kubectl describe node <name>
kubectl logs -n kube-system -l k8s-app=aws-node
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=<vpc_id>"
```

Check NAT gateway health and private route tables.

## Terraform warning: `resolve_conflicts` deprecated

During `terraform plan`, you may see:

```text
Warning: Deprecated value used ... resolve_conflicts
```

This comes from the AWS provider when EKS add-on resources are read for outputs. It is **non-blocking** and safe to ignore on plan/apply if add-ons use `resolve_conflicts_on_create` / `resolve_conflicts_on_update` (configured in `modules/eks/main.tf`).

To clear it fully, upgrade to `terraform-aws-modules/eks` v21 and AWS provider v6 (see [UPGRADE-21.0](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/UPGRADE-21.0.md)).

## Incident: PVC Pending

```bash
kubectl describe pvc <name>
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```

Verify EBS CSI add-on and IRSA role ARN in Terraform state.
