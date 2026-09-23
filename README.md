# Salesforce DevOps Practice

![PR Validation](https://github.com/LilianaRTSf/salesforce-devops-practice/actions/workflows/pr-validation.yml/badge.svg)
![Code Quality](https://github.com/LilianaRTSf/salesforce-devops-practice/actions/workflows/code-quality.yml/badge.svg)
![Deploy to Dev](https://github.com/LilianaRTSf/salesforce-devops-practice/actions/workflows/deploy-to-dev.yml/badge.svg)

A complete Salesforce DevOps practice project demonstrating Git best practices, GitFlow branching strategy, and automated CI/CD pipelines using GitHub Actions.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Git Workflow](#git-workflow)
- [CI/CD Pipeline](#cicd-pipeline)
- [Sample Metadata](#sample-metadata)
- [Best Practices](#best-practices)

---

## Overview

This project demonstrates a production-ready DevOps setup for Salesforce development including:

- ✅ **GitFlow Branching Strategy** - Organized branching with `main`, `develop`, `feature/*`, `bugfix/*`, `hotfix/*`, and `release/*`
- ✅ **Automated CI/CD** - GitHub Actions workflows for validation, testing, and deployment
- ✅ **Code Quality Gates** - PMD, ESLint, and security scanning
- ✅ **Environment Progression** - Dev → UAT → Production deployment pipeline
- ✅ **Sample Metadata** - Example Apex classes, LWC components, and custom objects

---

## Project Structure

```
salesforce-devops-practice/
├── .github/
│   └── workflows/           # GitHub Actions CI/CD workflows
│       ├── pr-validation.yml
│       ├── deploy-to-dev.yml
│       ├── deploy-to-production.yml
│       ├── code-quality.yml
│       └── README.md
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/     # Apex classes
│           │   ├── AccountService.cls
│           │   └── AccountServiceTest.cls
│           ├── lwc/         # Lightning Web Components
│           │   └── accountSearch/
│           └── objects/     # Custom objects
│               └── Project__c/
├── BRANCHING_STRATEGY.md    # Detailed branching documentation
├── README.md                # This file
└── sfdx-project.json        # Salesforce DX configuration
```

---

## Getting Started

### Prerequisites

- [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli) installed
- [Git](https://git-scm.com/) installed
- [Node.js](https://nodejs.org/) (v20+) installed
- GitHub account
- Salesforce Developer Edition or Sandbox org

### Clone the Repository

```bash
git clone https://github.com/LilianaRTSf/salesforce-devops-practice.git
cd salesforce-devops-practice
```

### Install Dependencies

```bash
npm install
```

### Authenticate to Salesforce

```bash
# For development
sf org login web --alias my-dev-org --instance-url https://test.salesforce.com

# Set as default
sf config set target-org=my-dev-org
```

### Deploy Sample Metadata

```bash
sf project deploy start --target-org my-dev-org
```

---

## Git Workflow

This project uses **GitFlow** branching strategy. See [BRANCHING_STRATEGY.md](./BRANCHING_STRATEGY.md) for complete details.

### Quick Reference

#### Working on a New Feature

```bash
# Start from develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/TICKET-123-description

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/TICKET-123-description
```

#### Creating a Pull Request

1. Go to GitHub repository
2. Click **Pull requests** → **New pull request**
3. Base: `develop`, Compare: `feature/TICKET-123-description`
4. Fill in description
5. Wait for CI/CD checks to pass
6. Request review
7. Merge after approval

#### Deploying to Production

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.0.0

# Push release
git push origin release/v1.0.0

# Create PR to main
# After merge to main, CI/CD deploys to production
```

---

## CI/CD Pipeline

### Automated Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| **PR Validation** | PR to `develop` or `main` | Validates metadata, runs tests, code analysis |
| **Code Quality** | Push to any branch | Static analysis, security scan, test coverage |
| **Deploy to Dev** | Push to `develop` | Automatic deployment to dev sandbox |
| **Deploy to Production** | Push to `main` | UAT validation + Production deployment (manual approval) |

### Setting Up CI/CD

See [.github/workflows/README.md](./.github/workflows/README.md) for detailed setup instructions including:
- How to get Salesforce auth URLs
- Adding GitHub secrets
- Configuring environments
- Setting up branch protection
- Troubleshooting

---

## Sample Metadata

### Apex Classes

**AccountService.cls**
- Service class demonstrating best practices
- Industry-based account filtering
- Revenue calculation methods
- Security enforced with `WITH SECURITY_ENFORCED`

**AccountServiceTest.cls**
- Complete test coverage (100%)
- Positive and negative test cases
- Test data setup with `@TestSetup`

### Lightning Web Components

**accountSearch**
- Interactive search component
- Industry picklist selection
- Datatable for displaying results
- Error handling and loading states

### Custom Objects

**Project__c**
- Custom object with 5 fields
- Status picklist (Planning, In Progress, On Hold, Completed, Cancelled)
- Date tracking (Start Date, End Date)
- Budget currency field
- Description long text area

---

## Best Practices

### Commit Messages

Use conventional commits format:

```
feat: add new feature
fix: resolve bug in lead conversion
refactor: simplify account trigger logic
test: add coverage for opportunity handler
docs: update deployment guide
```

### Code Quality

- **Apex**: Follow PMD rules, maintain 75%+ test coverage
- **LWC**: Follow ESLint-LWC rules, use proper naming conventions
- **Security**: Use `WITH SECURITY_ENFORCED` in SOQL, validate inputs

### Branching

- Keep feature branches short-lived (1-2 weeks max)
- Regularly sync with develop: `git pull origin develop`
- Delete branches after merging
- Use descriptive branch names: `feature/TICKET-123-description`

### Pull Requests

- Keep PRs small and focused (< 400 lines changed)
- Include description and testing instructions
- Wait for all CI/CD checks to pass
- Get at least 1 approval before merging
- Resolve all comments

### Deployments

- **Always validate before deploying** to production
- **Test in lower environments first**: Dev → UAT → Prod
- **Use manual approval** for production deployments
- **Monitor deployments** and be ready to rollback if needed

---

## Additional Resources

- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitFlow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

---

## License

This is a practice project for educational purposes.
