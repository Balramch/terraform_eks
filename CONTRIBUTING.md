# Contributing

## Workflow

1. Branch from `main` using `feature/<ticket>-short-description`.
2. Change code under `modules/` or `environments/<env>/`.
3. Run `make fmt` and `make validate ENV=dev`.
4. Open a PR; CI runs `fmt`, `validate`, and `tfsec`.
5. Obtain review from code owners (`CODEOWNERS`).
6. Apply via approved pipeline or controlled `make apply ENV=<env>`.

## Environment promotion

| Order | Environment | Notes |
|-------|-------------|-------|
| 1 | `dev` | First apply and smoke tests |
| 2 | `staging` | Production-like sizing and logging |
| 3 | `prod` | Change window, rollback plan required |

Never copy `terraform.tfstate` between environments. Each env has its own state key in S3.

## Module changes

- Keep modules generic; environment-specific values belong in `terraform.tfvars`.
- Document new variables in module `variables.tf` descriptions.
- Run `terraform fmt -recursive` before commit.

## Secrets

- Do not commit `terraform.tfvars`, `backend.hcl`, or kubeconfig files.
- Use AWS Secrets Manager / SSM for application secrets, not Terraform state.
