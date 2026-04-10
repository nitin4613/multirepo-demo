# Security Policy

## Overview

This project maintains security through multiple automated mechanisms and best practices.

## Security Features

### Dependency Management
- **Dependabot**: Automatically monitors and updates dependencies (npm, Gradle, GitHub Actions, and Docker base images) on a weekly basis
- **Dependency Review**: Pull requests are automatically scanned for known vulnerable dependencies using GitHub's dependency-review action
- Vulnerabilities at moderate severity and above will block PR merging

### Code Analysis
- **CodeQL**: Automatic code quality and security analysis for Java and JavaScript/TypeScript
- Runs on every push to main, pull requests to main, and weekly schedule
- Security event results are uploaded for tracking and remediation

### Secret Detection
- **Gitleaks**: Scans pull requests for secrets and sensitive information using zricethezav/gitleaks-action
- **GitHub Secret Scanning**: Organization-level secret scanning and push protection enabled
- Redacted output to prevent exposure of sensitive data

## Reporting Security Issues

### Responsible Disclosure

If you discover a security vulnerability, please report it responsibly:

1. **Do not** create public GitHub issues for security vulnerabilities
2. Email security concerns to the repository owner or your organization's security team
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested remediation (if available)

4. Allow reasonable time for the maintainers to address the issue before public disclosure
5. Coordinate disclosure timeline with the security team

### Security Updates

Security updates will be released as soon as practical after discovery and validation of vulnerabilities. Follow this repository for security updates and patches.

## Best Practices

When contributing to this project:
- Never commit secrets, API keys, or sensitive credentials
- Keep dependencies up to date by reviewing and merging Dependabot PRs
- Run local security checks before pushing code
- Review CodeQL and Gitleaks results on pull requests
- Report any suspicious activity or security concerns promptly

## Questions or Feedback

For questions about this security policy or suggestions for improvements, please contact the repository maintainers or your organization's security team.
