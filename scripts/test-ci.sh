#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_ROOT/.circleci/config.yml"

echo "======================================"
echo "CircleCI Testing Helper"
echo "======================================"
echo ""

show_help() {
    echo "Usage: ./scripts/test-ci.sh [command]"
    echo ""
    echo "Commands:"
    echo "  validate       Validate config syntax (fast, no execution)"
    echo "  local <job>    Run a job locally with Docker (limited features)"
    echo "  run            Trigger pipeline with local config (requires org opt-in)"
    echo "  process        Process config and show expanded YAML"
    echo "  help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./scripts/test-ci.sh validate"
    echo "  ./scripts/test-ci.sh local unit-tests"
    echo "  ./scripts/test-ci.sh run"
    echo ""
}

validate_config() {
    echo "Validating CircleCI config..."
    echo ""
    circleci config validate "$CONFIG_FILE"
    echo ""
    echo "✓ Config is valid!"
}

process_config() {
    echo "Processing and expanding config..."
    echo "(This resolves orbs, commands, etc.)"
    echo ""
    circleci config process "$CONFIG_FILE"
}

run_local() {
    JOB_NAME=$1
    if [ -z "$JOB_NAME" ]; then
        echo "Error: Please specify a job name"
        echo "Usage: ./scripts/test-ci.sh local <job-name>"
        echo ""
        echo "Available jobs in config:"
        grep -E "^  [a-z].*:" "$CONFIG_FILE" | head -20 | sed 's/://g' | sed 's/^  /  - /'
        exit 1
    fi
    
    echo "Running job '$JOB_NAME' locally with Docker..."
    echo ""
    echo "⚠️  Limitations:"
    echo "   - Only docker executor works (not machine)"
    echo "   - Caching is skipped"
    echo "   - Workflows are not supported"
    echo "   - Environment variables from contexts not available"
    echo ""
    
    PROCESSED_CONFIG="/tmp/processed-config.yml"
    circleci config process "$CONFIG_FILE" > "$PROCESSED_CONFIG"
    
    circleci local execute -c "$PROCESSED_CONFIG" "$JOB_NAME"
}

trigger_pipeline() {
    echo "Triggering pipeline with local config..."
    echo ""
    echo "⚠️  Prerequisites:"
    echo "   1. Org admin must enable in Organization Settings > Advanced:"
    echo "      'Allow triggering pipelines with unversioned config'"
    echo "   2. You must be authenticated: circleci setup"
    echo ""
    
    if circleci pipeline run -h &>/dev/null; then
        echo "Running: circleci pipeline run --config $CONFIG_FILE"
        circleci pipeline run --config "$CONFIG_FILE"
    else
        echo "Error: 'circleci pipeline run' not available."
        echo "Update your CLI: circleci update"
        echo ""
        echo "Alternative: Push to a test branch without PR:"
        echo "  git push origin HEAD:test/ci-$(date +%s)"
    fi
}

# Main
case "${1:-help}" in
    validate)
        validate_config
        ;;
    local)
        run_local "$2"
        ;;
    run)
        trigger_pipeline
        ;;
    process)
        process_config
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
