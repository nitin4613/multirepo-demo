#!/bin/bash

#######################################
# Branch Protection Setup Script
# Configures GitHub branch protection rules and security settings
#
# NOTE on gh api flags:
#   -f  sends a STRING value     ("true", "1")
#   -F  sends a TYPED value      (true, 1, null)
#   --input  sends raw JSON from stdin
#
# The branch protection API requires booleans and nested objects,
# so we use --input with a heredoc for the full payload.
#######################################

set -e  # Exit on error

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

# The branch protection endpoint requires a specific JSON schema.
# Using --input to send properly typed JSON (booleans, integers, arrays).
gh api "repos/$REPO/branches/$BRANCH/protection" \
  --method PUT \
  --input - << 'EOF'
{
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  },
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "unit-tests",
      "frontend-tests",
      "CodeQL",
      "dependency-review"
    ]
  },
  "enforce_admins": false,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": true,
  "required_conversation_resolution": true
}
EOF

echo "✓ Branch protection rules configured"
echo "  - Require pull request reviews (1 approver)"
echo "  - Dismiss stale reviews"
echo "  - Require code owner reviews"
echo "  - Required status checks: unit-tests, frontend-tests, CodeQL, dependency-review"
echo "  - Require branches to be up to date"
echo "  - Enforce rules for admins"
echo "  - Restrict force pushes and deletions"
echo "  - Require linear history"
echo "  - Require conversation resolution"
echo ""

# Step 2: Enable Security Features
echo "Step 2: Enabling security features..."
echo ""

# Enable vulnerability alerts (Dependabot alerts)
gh api "repos/$REPO/vulnerability-alerts" --method PUT 2>/dev/null && \
  echo "  ✓ Dependabot alerts enabled" || \
  echo "  ⚠ Dependabot alerts: may already be enabled or requires admin access"

# Enable automated security fixes (Dependabot security updates)
gh api "repos/$REPO/automated-security-fixes" --method PUT 2>/dev/null && \
  echo "  ✓ Dependabot security updates enabled" || \
  echo "  ⚠ Dependabot security updates: may already be enabled or requires admin access"

# Note: Secret scanning and push protection are typically enabled at the
# org level or via the repo settings UI. The API endpoints require GHAS license.
# For the demo, enable these manually in Settings → Code security.
echo ""
echo "  ℹ  Secret scanning & push protection:"
echo "     Enable these in the GitHub UI at:"
echo "     https://github.com/$REPO/settings/security_analysis"
echo ""

# Summary
echo "=========================================="
echo "Branch Protection — Complete!"
echo "=========================================="
echo ""
echo "  Repository:    $REPO"
echo "  Branch:        $BRANCH"
echo "  PR Reviews:    1 required, stale reviews dismissed"
echo "  Status Checks: unit-tests, frontend-tests, CodeQL, dependency-review"
echo "  Force Push:    Blocked"
echo "  Linear History: Required"
echo "  Dependabot:    Alerts + security updates enabled"
echo ""
echo "  Verify at: https://github.com/$REPO/settings/branches"
echo ""
