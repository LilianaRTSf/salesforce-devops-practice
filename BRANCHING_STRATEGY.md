# Branching Strategy - GitFlow

This project uses **GitFlow** branching strategy for organized development and deployment.

## Branch Types

### 1. `main` - Production Branch
- **Purpose**: Contains production-ready code
- **Protection**: Protected branch, requires PR approval
- **Deploys to**: Production org
- **Naming**: `main`

### 2. `develop` - Integration Branch
- **Purpose**: Integration branch for ongoing development
- **Protection**: Protected branch, requires PR approval
- **Deploys to**: Dev sandbox
- **Naming**: `develop`

### 3. `feature/*` - Feature Branches
- **Purpose**: New features or enhancements
- **Created from**: `develop`
- **Merged to**: `develop`
- **Naming**: `feature/<ticket-id>-<short-description>`
- **Example**: `feature/JIRA-123-add-account-validation`

### 4. `bugfix/*` - Bug Fix Branches
- **Purpose**: Bug fixes during development
- **Created from**: `develop`
- **Merged to**: `develop`
- **Naming**: `bugfix/<ticket-id>-<short-description>`
- **Example**: `bugfix/JIRA-456-fix-lead-conversion`

### 5. `release/*` - Release Branches
- **Purpose**: Prepare for production release
- **Created from**: `develop`
- **Merged to**: `main` AND `develop`
- **Deploys to**: UAT/Staging sandbox
- **Naming**: `release/v<version>`
- **Example**: `release/v1.2.0`

### 6. `hotfix/*` - Hotfix Branches
- **Purpose**: Emergency fixes for production
- **Created from**: `main`
- **Merged to**: `main` AND `develop`
- **Naming**: `hotfix/<ticket-id>-<short-description>`
- **Example**: `hotfix/JIRA-789-critical-security-fix`

---

## Workflow Examples

### Working on a New Feature

```bash
# 1. Start from develop
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/JIRA-123-add-account-validation

# 3. Make changes, commit regularly
git add .
git commit -m "Add account validation rule"

# 4. Push to remote
git push origin feature/JIRA-123-add-account-validation

# 5. Create Pull Request on GitHub
# - Base: develop
# - Compare: feature/JIRA-123-add-account-validation

# 6. After PR approval and merge, delete local branch
git checkout develop
git pull origin develop
git branch -d feature/JIRA-123-add-account-validation
```

### Creating a Release

```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# 2. Update version numbers, run final tests
# Make any last-minute fixes

# 3. Push release branch
git push origin release/v1.2.0

# 4. Create PR to main (production deployment)
# 5. After merge to main, also merge back to develop
```

### Emergency Hotfix

```bash
# 1. Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/JIRA-789-critical-fix

# 2. Fix the issue
git add .
git commit -m "Fix critical security vulnerability"

# 3. Push and create PRs to both main AND develop
git push origin hotfix/JIRA-789-critical-fix
```

---

## Branch Protection Rules

### `main` branch
- Require pull request reviews (1+ approvers)
- Require status checks to pass (CI/CD validation)
- Require branches to be up to date
- No direct commits allowed

### `develop` branch
- Require pull request reviews (1+ approvers)
- Require status checks to pass
- Allow force push with lease (for rebasing)

---

## Best Practices

1. **Keep branches short-lived**: Feature branches should be merged within 1-2 weeks
2. **Commit messages**: Use conventional commits format
   - `feat:` new feature
   - `fix:` bug fix
   - `refactor:` code refactoring
   - `test:` adding tests
   - `docs:` documentation changes
3. **Pull before push**: Always `git pull origin develop` before creating a new branch
4. **Regular syncing**: Update your feature branch with develop regularly
5. **Small PRs**: Keep pull requests focused and reviewable (< 400 lines changed)
6. **Delete merged branches**: Clean up branches after merging

---

## Environment Mapping

| Branch | Salesforce Org | Purpose |
|--------|---------------|---------|
| `main` | Production | Live customer data |
| `release/*` | UAT/Staging | Pre-production testing |
| `develop` | Dev Sandbox | Integration testing |
| `feature/*` | Scratch Orgs | Developer feature work |

---

## CI/CD Integration

- **On feature branch push**: Run validation, tests, code analysis
- **On PR to develop**: Deploy to dev sandbox (validation only)
- **On merge to develop**: Deploy to dev sandbox (with tests)
- **On PR to main**: Deploy to UAT, require manual approval
- **On merge to main**: Deploy to production with full test suite
