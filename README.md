# CarGurus Multi-Repo Demo

Demonstrates CircleCI's Release Agent with Argo Rollouts progressive delivery, multi-region deployments, and Showroom IDP integration.

## What This Repo Shows

| Feature | Description |
|---------|-------------|
| Manual Deployment Mode | Production deploys require explicit Showroom trigger |
| CircleCI Release Agent | Kubernetes-native release tracking via labels |
| Argo Rollouts | Canary deployments with Prometheus-based analysis |
| Multi-Region | Parallel deploys to NA (us-west-2) and EU (eu-west-2) |
| API & Webhook Triggers | Deploy/rollback via Showroom API or webhook |
| Helm + Istio | Service mesh with progressive traffic shifting |

## Repository Structure

```
.circleci/
  config.yml          # CI/Staging pipeline (main entry point)
  deploy.yml          # Production deployment (Release Management UI)
  rollback.yml        # Production rollback (Release Management UI)
  api-deploy.yml      # Production deployment (Showroom API/Webhook)
  api-rollback.yml    # Production rollback (Showroom API/Webhook)
  pr-cycle.yml        # PR validation workflow
helm/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml
    rollout.yaml
    service.yaml
    analysis.yaml
    virtual-service.yaml
    loadtest-job.yaml
src/                  # Java Spring Boot app + React frontend
tests/                # Playwright E2E tests
scripts/test-ci.sh    # Local CI testing helper
service-meta.yml      # Service + IDP configuration
```

## Pipeline Overview

### CI/Staging

Push to main triggers: build, unit tests, Docker publish, staging deploy (NA + EU), smoke tests, E2E tests, then deployment qualification check.

### Production Deployment

Triggered via Release Management UI or Showroom IDP:

1. Promote Docker image
2. Deploy canary to NA and EU (parallel)
3. Release Agent monitors deployments
4. Argo Rollouts runs Prometheus-based analysis
5. Full rollout on success
6. Create GitHub release

### Rollback

Same trigger methods. Aborts in-progress rollouts, deploys previous version via Helm, waits for completion.

## Multi-Region

| Region | AWS Region | EKS Cluster | Release Plan |
|--------|------------|-------------|--------------|
| NA (namer) | us-west-2 | cera-usw2-namer | Car-Gurus-Multi-Repo-Production-NA |
| EU (emea) | eu-west-2 | cera-euw2-emea | Car-Gurus-Multi-Repo-Production-EU |

## Configuration Files

| File | Pipeline | Trigger |
|------|----------|---------|
| `config.yml` | CI/Staging | Push to main, PR |
| `deploy.yml` | Production Deploy | CircleCI Release Management UI |
| `rollback.yml` | Production Rollback | CircleCI Release Management UI |
| `api-deploy.yml` | Production Deploy | Showroom IDP (API/Webhook) |
| `api-rollback.yml` | Production Rollback | Showroom IDP (API/Webhook) |
| `pr-cycle.yml` | PR Validation | Pull Request |

## Deployment Mode

Set in `service-meta.yml`:

- **auto**: Deploy to production automatically after E2E passes
- **manual**: Requires explicit trigger via Showroom IDP or Release Management UI

## Trigger Methods

### CircleCI Release Management UI

Deploy or rollback directly from the CircleCI dashboard.

### Showroom API

```bash
curl -X POST "https://circleci.com/api/v2/project/github/AwesomeCICD/cargurus-multi-repo/pipeline" \
  -H "Circle-Token: ${CIRCLE_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "parameters": {
      "service_name": "cargurus-multi-repo",
      "tag": "123",
      "namespace": "cargurus-prod",
      "trigger_mode": "showroom",
      "showroom_request_id": "req-abc123",
      "showroom_callback_url": "https://showroom.example.com/api/callbacks",
      "requested_by": "user@company.com"
    }
  }'
```

### Webhook

POST to the configured webhook endpoint:

```json
{
  "service_name": "cargurus-multi-repo",
  "tag": "123",
  "namespace": "cargurus-prod",
  "region": "NA",
  "request_id": "req-abc123",
  "callback_url": "https://showroom.example.com/api/callbacks",
  "requested_by": "user@company.com"
}
```

## Showroom Parameters

| Parameter | Description |
|-----------|-------------|
| `service_name` | Service to deploy/rollback |
| `environment` | `Staging` or `Production` |
| `region` | `NA` or `EU` (maps to namer/emea) |
| `namespace` | Kubernetes namespace |
| `tag` | Docker image tag (required) |
| `trigger_mode` | `showroom`, `manual`, `webhook`, `auto` |
| `showroom_request_id` | Request ID for callback correlation |
| `showroom_callback_url` | URL for status updates |
| `requested_by` | User who initiated the action |

## Callback Events

The pipeline sends status callbacks to Showroom:

| Event | Status |
|-------|--------|
| `deployment_started` | in_progress |
| `deployment_progress` | in_progress |
| `deployment_success` | success |
| `deployment_failure` | failed |
| `rollback_started` | in_progress |
| `rollback_success` | success |
| `rollback_failure` | failed |

## Prerequisites

- CircleCI account with Release Management enabled
- AWS EKS clusters in us-west-2 and eu-west-2
- Argo Rollouts and CircleCI Release Agent installed in clusters
- Prometheus for canary analysis metrics
- CircleCI contexts: `cargurus_demo` (tokens), `cargurus-oidc` (AWS OIDC)
