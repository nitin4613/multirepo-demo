# Multi-Repo Demo

Demonstrates GitHub's end-to-end DevSecOps platform with GitHub Actions CI/CD, progressive delivery via Argo Rollouts, multi-region deployments, and native security tooling.

## What This Repo Shows

| Feature | GitHub Capability |
|---------|-------------------|
| CI/CD Pipelines | GitHub Actions with reusable workflows and environments |
| Code Security | CodeQL SAST scanning (Java + JavaScript) |
| Supply Chain Security | Dependabot + Dependency Review Action |
| Secret Protection | GitHub Secret Scanning + Push Protection + Gitleaks |
| Branch Protection | Required reviews, status checks, signed commits |
| Progressive Delivery | Argo Rollouts canary with Prometheus analysis |
| Multi-Region Deploy | Parallel deploys to NA (us-west-2) and EU (eu-west-2) |
| Container Registry | GitHub Packages (ghcr.io) with SBOM attestation |
| Release Management | GitHub Releases with auto-generated changelogs |
| Environment Gates | GitHub Environments with required reviewers |

## Repository Structure

```
.github/
  workflows/
    ci.yml               # CI pipeline (build, test, staging deploy, E2E)
    deploy-prod.yml       # Production deployment with canary rollout
    rollback.yml          # Production rollback
    codeql.yml            # CodeQL security scanning (scheduled + PR)
    pr-validation.yml     # PR checks (lint, test, dependency review)
    dependency-review.yml # Vulnerable dependency blocking
    secret-scanning.yml   # Gitleaks secret detection
  dependabot.yml          # Automated dependency updates
  CODEOWNERS              # Code ownership for review routing
.circleci/                # Legacy CircleCI configs (migration reference)
helm/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml       # Standard K8s deployment
    rollout.yaml          # Argo Rollouts canary strategy
    service.yaml          # ClusterIP service
    analysis.yaml         # Prometheus-based canary analysis
    virtual-service.yaml  # Istio traffic management
    loadtest-job.yaml     # Load testing for canary validation
src/                      # Java Spring Boot backend + React frontend
tests/                    # Playwright E2E tests
service-meta.yml          # Service + deployment configuration
SECURITY.md               # Security policy and disclosure
```

## Pipeline Overview

### CI Pipeline (ci.yml)

Push to main triggers the full pipeline:

1. **Unit Tests** — Java (Gradle + JaCoCo) and Frontend (Jest + ESLint)
2. **Build & Publish** — Docker multi-stage build → ghcr.io with layer caching
3. **Deployment Gate** — Checks `service-meta.yml` for freeze/mode
4. **Staging Deploy** — Parallel Helm deploys to NA + EU via AWS OIDC
5. **Smoke Tests** — Health check validation per region
6. **E2E Tests** — Playwright with 4-shard parallelism
7. **Production Trigger** — Dispatches production deploy workflow

### Production Deployment (deploy-prod.yml)

Triggered via `workflow_dispatch` or called from CI:

1. **Environment Approval** — GitHub Environment protection rules
2. **Promote Image** — Tag as `prod-{version}`
3. **Canary Deploy** — Argo Rollouts: 30% → 50% → 70% → 90% → 100%
4. **Prometheus Analysis** — Automated success rate + latency checks
5. **Full Rollout** — Promote on analysis pass
6. **GitHub Release** — Auto-generated changelog

### Rollback (rollback.yml)

Manual trigger with environment approval:
- Abort in-progress rollouts
- Helm rollback to target version
- Verify deployment health

## Security Features

### GitHub Advanced Security

- **CodeQL** — Static analysis for Java and JavaScript on every PR and weekly schedule
- **Secret Scanning** — Detects leaked credentials in code and PR diffs
- **Push Protection** — Blocks pushes containing secrets before they hit the repo
- **Dependency Review** — Blocks PRs introducing known vulnerable dependencies

### Dependabot

Automated updates for:
- npm packages (weekly)
- Gradle dependencies (weekly)
- GitHub Actions versions (weekly)
- Docker base images (weekly)

### Branch Protection

- Required pull request reviews (1+ approver)
- Required status checks (unit tests, lint, CodeQL, dependency review)
- Require signed commits
- No force pushes to main
- Dismiss stale reviews on new commits

## Multi-Region

| Region | AWS Region | EKS Cluster | Namespace |
|--------|------------|-------------|-----------|
| NA (namer) | us-west-2 | cera-usw2-namer | demo-prod |
| EU (emea) | eu-west-2 | cera-euw2-emea | demo-prod |

## GitHub Environments

| Environment | Protection Rules |
|-------------|-----------------|
| staging | Required status checks |
| production | Required reviewers + wait timer |

## Prerequisites

- GitHub repo with Actions enabled
- GitHub Advanced Security license (for CodeQL, secret scanning)
- AWS EKS clusters in us-west-2 and eu-west-2
- Argo Rollouts installed in clusters
- Prometheus for canary analysis
- GitHub Secrets: `AWS_ROLE_ARN`, `KUBE_CONFIG_*`
