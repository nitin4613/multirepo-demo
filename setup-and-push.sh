#!/bin/bash
set -e

echo "========================================"
echo "  Multi-Repo Demo - Setup & Push Script"
echo "========================================"
echo ""

cd "$(dirname "$0")"

# Step 1: Remove git lock file
echo "Step 1: Removing git lock file..."
rm -f .git/index.lock
echo "  OK Lock file removed"
echo ""

# Step 2: Remove old Java package directories
echo "Step 2: Cleaning old Java package directories..."
if [ -d "src/main/java/com/cargurus" ]; then
  rm -rf src/main/java/com/cargurus
  echo "  OK Removed src/main/java/com/cargurus"
else
  echo "  OK Already clean (src/main/java/com/cargurus not found)"
fi

if [ -d "src/test/java/com/cargurus" ]; then
  rm -rf src/test/java/com/cargurus
  echo "  OK Removed src/test/java/com/cargurus"
else
  echo "  OK Already clean (src/test/java/com/cargurus not found)"
fi
echo ""

# Step 3: Verify new Java files exist
echo "Step 3: Verifying new Java package structure..."
if [ -f "src/main/java/com/multirepo/demo/service/Application.java" ] && \
   [ -f "src/main/java/com/multirepo/demo/service/HealthController.java" ] && \
   [ -f "src/test/java/com/multirepo/demo/service/HealthControllerTest.java" ]; then
  echo "  OK All new Java files present"
else
  echo "  FAIL ERROR: New Java files missing. Check src/main/java/com/multirepo/demo/service/"
  exit 1
fi
echo ""

# Step 4: Remove this script and guide files from repo (don't commit them)
echo "Step 4: Removing setup artifacts from repo..."
rm -f DEMO-TALK-TRACK.md STEP-BY-STEP-GUIDE.md
echo "  OK Removed guide files (should already be on Desktop)"
echo ""

# Step 5: Verify zero cargurus/showroom references
echo "Step 5: Scanning for remaining 'cargurus' or 'showroom' references..."
CARGURUS_COUNT=$(grep -ri "cargurus" --include="*.yml" --include="*.yaml" --include="*.java" --include="*.tsx" --include="*.ts" --include="*.json" --include="*.gradle" --include="*.md" --include="*.tpl" -l 2>/dev/null | wc -l | tr -d ' ')
SHOWROOM_COUNT=$(grep -ri "showroom" --include="*.yml" --include="*.yaml" --include="*.java" --include="*.tsx" --include="*.ts" --include="*.json" --include="*.gradle" --include="*.md" --include="*.tpl" -l 2>/dev/null | wc -l | tr -d ' ')

if [ "$CARGURUS_COUNT" -gt 0 ] || [ "$SHOWROOM_COUNT" -gt 0 ]; then
  echo "  NOTE WARNING: Found $CARGURUS_COUNT files with 'cargurus', $SHOWROOM_COUNT with 'showroom'"
  grep -ri "cargurus\|showroom" --include="*.yml" --include="*.yaml" --include="*.java" --include="*.tsx" --include="*.ts" --include="*.json" --include="*.gradle" --include="*.md" --include="*.tpl" -l 2>/dev/null
  echo "  Continuing anyway..."
else
  echo "  OK Zero matches - clean!"
fi
echo ""

# Step 6: Update git remote
echo "Step 6: Setting git remote to nitin4613/multirepo-demo..."
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:nitin4613/multirepo-demo.git
echo "  OK Remote set to: $(git remote get-url origin)"
echo ""

# Step 7: Stage everything
echo "Step 7: Staging all changes..."
git add -A
echo "  OK Staged $(git diff --cached --stat | tail -1)"
echo ""

# Step 8: Show what will be committed
echo "Step 8: Files to be committed:"
echo "  Modified:"
git diff --cached --name-only --diff-filter=M | sed 's/^/    /'
echo "  Added:"
git diff --cached --name-only --diff-filter=A | sed 's/^/    /'
echo "  Deleted:"
git diff --cached --name-only --diff-filter=D | sed 's/^/    /'
echo ""

# Step 9: Commit
echo "Step 9: Committing..."
git commit -m "Migrate CI/CD to GitHub Actions with full DevSecOps tooling

- Add GitHub Actions workflows: CI, production deploy, rollback
- Add CodeQL scanning for Java and JavaScript
- Add Dependabot for npm, Gradle, Docker, and Actions
- Add dependency review to block vulnerable PRs
- Add secret scanning with gitleaks
- Add branch protection and environment setup scripts
- Add CODEOWNERS and SECURITY.md
- Migrate Java package from com.cargurus to com.multirepo.demo
- Update Helm charts, Kubernetes configs, and service metadata
- Update all references to use new naming convention"
echo ""
echo "  OK Committed successfully"
echo ""

# Step 10: Push
echo "Step 10: Pushing to GitHub..."
echo ""
echo "  IMPORTANT: Make sure you've created the repo first:"
echo "  https://github.com/new -> name it 'multirepo-demo' under nitin4613"
echo ""
read -p "  Have you created the repo on GitHub? (y/n): " CONFIRM
if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
  git branch -M main
  git push -u origin main
  echo ""
  echo "  OK Pushed successfully!"
else
  echo ""
  echo "  Skipping push. When ready, run:"
  echo "    git branch -M main"
  echo "    git push -u origin main"
fi

echo ""
echo "========================================"
echo "  DONE! Next steps:"
echo "========================================"
echo ""
echo "  1. Go to https://github.com/nitin4613/multirepo-demo/settings/security_analysis"
echo "     -> Enable Dependabot alerts, security updates, secret scanning, push protection"
echo ""
echo "  2. Run branch protection setup:"
echo "     gh auth login"
echo "     ./scripts/setup-branch-protection.sh"
echo "     ./scripts/setup-environments.sh"
echo ""
echo "  3. Push a small change to trigger workflows:"
echo "     echo '' >> README.md && git add README.md && git commit -m 'docs: trigger CI' && git push"
echo ""
echo "  4. Open your DEMO-TALK-TRACK.md from Desktop for tomorrow"
echo ""
echo "  Good luck! "
