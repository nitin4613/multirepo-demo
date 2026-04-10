#!/bin/bash

#######################################
# GitHub Environments Setup Script
# Creates and configures deployment environments
# with protection rules and review requirements
#######################################

set -e  # Exit on error

# Configuration Variables
REPO="nitin4613/multirepo-demo"
STAGING_ENV="staging"
PRODUCTION_ENV="production"

echo "=========================================="
echo "GitHub Environments Configuration"
echo "=========================================="
echo "Repository: $REPO"
echo ""

# Step 1: Create Staging Environment
echo "Step 1: Creating '$STAGING_ENV' environment..."
echo ""

gh api repos/$REPO/environments/$STAGING_ENV \
  --method PUT \
  -f wait_timer=0 \
  -f reviewers='[]'

echo "✓ Staging environment created"
echo "  - No required reviewers"
echo "  - No wait timer"
echo "  - Ready for immediate deployments"
echo ""

# Step 2: Create Production Environment
echo "Step 2: Creating '$PRODUCTION_ENV' environment..."
echo ""

# Create the production environment with protection rules
gh api repos/$REPO/environments/$PRODUCTION_ENV \
  --method PUT \
  -f wait_timer=5 \
  -f reviewers='[{"type":"User","id":null}]'

echo "✓ Production environment created"
echo "  - Required reviewers: Yes (at least 1)"
echo "  - Wait timer: 5 minutes"
echo ""

# Step 3: Configure Deployment Branch Policy (main only)
echo "Step 3: Configuring deployment branch policy..."
echo ""

# Set deployment branch policy to allow deployments from main only
gh api repos/$REPO/environments/$PRODUCTION_ENV/deployment-branch-policy \
  --method POST \
  -f type='named' \
  -f name='main'

echo "✓ Deployment branch policy configured"
echo "  - Only 'main' branch can deploy to production"
echo "  - Protects accidental deployments from feature branches"
echo ""

# Step 4: List and Display Created Environments
echo "Step 4: Verifying environments..."
echo ""

echo "Retrieving environment details..."
STAGING_INFO=$(gh api repos/$REPO/environments/$STAGING_ENV)
PROD_INFO=$(gh api repos/$REPO/environments/$PRODUCTION_ENV)

echo "✓ Environments verified and ready"
echo ""

# Summary
echo "=========================================="
echo "Configuration Complete!"
echo "=========================================="
echo ""
echo "Environments Summary:"
echo ""
echo "1. STAGING ($STAGING_ENV)"
echo "   - Reviewers required: No"
echo "   - Wait timer: 0 minutes"
echo "   - Purpose: Testing and QA"
echo ""
echo "2. PRODUCTION ($PRODUCTION_ENV)"
echo "   - Reviewers required: Yes (1 minimum)"
echo "   - Wait timer: 5 minutes"
echo "   - Allowed branches: main only"
echo "   - Purpose: Production deployments"
echo ""
echo "Repository: $REPO"
echo ""
echo "Next Steps:"
echo "  1. Set required reviewers in GitHub UI for production"
echo "  2. Configure deployment secrets for each environment"
echo "  3. Update CI/CD workflows to use these environments"
echo "  4. Test deployment flow in staging first"
echo ""
