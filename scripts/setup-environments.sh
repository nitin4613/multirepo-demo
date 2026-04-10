#!/bin/bash

#######################################
# GitHub Environments Setup Script
# Creates and configures deployment environments
# with protection rules and review requirements
#
# NOTE: The environments API requires properly typed JSON.
# We use --input with heredocs to ensure correct types.
#######################################

set -e  # Exit on error

REPO="nitin4613/multirepo-demo"
STAGING_ENV="staging"
PRODUCTION_ENV="production"

echo "=========================================="
echo "GitHub Environments Configuration"
echo "=========================================="
echo "Repository: $REPO"
echo ""

# Step 1: Get the authenticated user's ID (needed for reviewer config)
echo "Step 1: Getting your GitHub user ID..."
USER_ID=$(gh api user --jq '.id')
echo "  ✓ User ID: $USER_ID"
echo ""

# Step 2: Create Staging Environment (no protection rules)
echo "Step 2: Creating '$STAGING_ENV' environment..."
echo ""

gh api "repos/$REPO/environments/$STAGING_ENV" \
  --method PUT \
  --input - << 'EOF'
{
  "wait_timer": 0,
  "prevent_self_review": false,
  "reviewers": [],
  "deployment_branch_policy": null
}
EOF

echo "  ✓ Staging environment created"
echo "    - No required reviewers"
echo "    - No wait timer"
echo "    - Any branch can deploy"
echo ""

# Step 3: Create Production Environment (with protection rules)
echo "Step 3: Creating '$PRODUCTION_ENV' environment..."
echo ""

# Build the JSON payload with the actual user ID for reviewers
gh api "repos/$REPO/environments/$PRODUCTION_ENV" \
  --method PUT \
  --input - << EOF
{
  "wait_timer": 5,
  "prevent_self_review": false,
  "reviewers": [
    {
      "type": "User",
      "id": $USER_ID
    }
  ],
  "deployment_branch_policy": {
    "protected_branches": false,
    "custom_branch_policies": true
  }
}
EOF

echo "  ✓ Production environment created"
echo "    - Required reviewer: you ($USER_ID)"
echo "    - Wait timer: 5 minutes"
echo "    - Custom branch policy enabled"
echo ""

# Step 4: Add deployment branch policy (main only)
echo "Step 4: Restricting production deploys to 'main' branch..."
echo ""

gh api "repos/$REPO/environments/$PRODUCTION_ENV/deployment-branch-policies" \
  --method POST \
  --input - << 'EOF'
{
  "name": "main",
  "type": "branch"
}
EOF

echo "  ✓ Only 'main' branch can deploy to production"
echo ""

# Summary
echo "=========================================="
echo "Environments — Complete!"
echo "=========================================="
echo ""
echo "  STAGING"
echo "    Reviewers: None"
echo "    Wait timer: 0 min"
echo "    Branches: Any"
echo ""
echo "  PRODUCTION"
echo "    Reviewers: You (nitin4613)"
echo "    Wait timer: 5 min"
echo "    Branches: main only"
echo ""
echo "  Verify at: https://github.com/$REPO/settings/environments"
echo ""
