#!/bin/bash

#######################################
# Branch Protection Setup Script
# Configures GitHub branch protection rules and security settings
# for demonstration and production use
#######################################

set -e  # Exit on error

# Configuration Variables
REPO="nitin4613/multirepo-demo"
BRANCH="main"

echo "=========================================="
echo "GitHub Branch Protection Configuration"
echo "=========================================="
echo "Repository: $REPO"
echo "Branch: $BRANCH"
echo ""

# Step 1: Configure Branch Protection Rules
echo "Step 1: Configuring branch protection rules..."
echo ""

gh api repos/$REPO/branches/$BRANCH/protection \
  --method PUT \
  -f required_pull_request_reviews.dismiss_stale_reviews=true \
  -f required_pull_request_reviews.require_code_owner_reviews=false \
  -f required_pull_request_reviews.required_approving_review_count=1 \
  -f required_status_checks.strict=true \
  -f required_status_checks.contexts='["unit-tests","frontend-tests","CodeQL","dependency-review"]' \
  -f enforce_admins=true \
  -f allow_force_pushes=false \
  -f allow_deletions=false \
  -f require_linear_history=true \
  -f require_conversation_resolution=true

echo "✓ Branch protection rules configured"
echo "  - Require pull request reviews (1 approver)"
echo "  - Dismiss stale reviews"
echo "  - Required status checks: unit-tests, frontend-tests, CodeQL, dependency-review"
echo "  - Require branches to be up to date"
echo "  - Enforce rules for admins"
echo "  - Restrict force pushes"
echo "  - Require linear history"
echo "  - Require conversation resolution"
echo ""

# Step 2: Enable Push Protection and Secret Scanning
echo "Step 2: Enabling push protection and secret scanning..."
echo ""

# Enable Dependabot alerts (requires GitHub Advanced Security)
gh api repos/$REPO \
  --method PATCH \
  -f dependabot_alerts_enabled=true \
  -f dependabot_security_updates_enabled=true \
  -f secret_scanning_enabled=true \
  -f secret_scanning_push_protection_enabled=true

echo "✓ Security features enabled"
echo "  - Dependabot alerts"
echo "  - Dependabot security updates"
echo "  - Secret scanning"
echo "  - Push protection"
echo ""

# Step 3: Enable Dependabot Security Updates
echo "Step 3: Configuring Dependabot security updates..."
echo ""

# Note: Dependabot security updates can also be configured via dependency alerts
# The above patch already enables dependabot_security_updates_enabled

echo "✓ Dependabot security updates enabled"
echo "  - Will automatically create PRs for security vulnerabilities"
echo ""

# Summary
echo "=========================================="
echo "Configuration Complete!"
echo "=========================================="
echo ""
echo "Branch Protection Summary:"
echo "  Repository:    $REPO"
echo "  Branch:        $BRANCH"
echo "  Protections:   7 rules configured"
echo "  Security:      Push protection, secret scanning, Dependabot enabled"
echo ""
echo "Next Steps:"
echo "  1. Review branch protection rules in GitHub web UI"
echo "  2. Configure Dependabot settings in repository settings"
echo "  3. Set up required reviewers for critical changes"
echo ""
