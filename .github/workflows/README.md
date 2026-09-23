# GitHub Actions Workflows

This directory contains CI/CD workflows for automated Salesforce deployments.

## Workflows Overview

### 1. **PR Validation** (`pr-validation.yml`)
**Trigger:** Pull requests to `develop` or `main` branches

**What it does:**
- Runs Salesforce Code Analyzer (PMD, ESLint)
- Validates metadata against target org (check-only deployment)
- Runs local tests
- Comments PR with validation status

**Required Secrets:**
- `SF_AUTH_URL` - Salesforce auth URL for validation org

---

### 2. **Deploy to Dev** (`deploy-to-dev.yml`)
**Trigger:** Push to `develop` branch or manual workflow dispatch

**What it does:**
- Deploys to Dev Sandbox
- Runs local tests
- Creates deployment summary
- Opens issue on deployment failure

**Required Secrets:**
- `SF_DEV_AUTH_URL` - Salesforce auth URL for dev sandbox

---

### 3. **Deploy to Production** (`deploy-to-production.yml`)
**Trigger:** Push to `main` branch or manual workflow dispatch

**What it does:**
1. **Validate in UAT** (check-only)
2. **Deploy to Production** (requires manual approval)
3. Creates GitHub release on success
4. Opens critical issue on failure

**Required Secrets:**
- `SF_UAT_AUTH_URL` - Salesforce auth URL for UAT sandbox
- `SF_PROD_AUTH_URL` - Salesforce auth URL for production org

---

### 4. **Code Quality Checks** (`code-quality.yml`)
**Trigger:** Push to any branch or pull request

**What it does:**
- Static code analysis (PMD for Apex)
- ESLint analysis (LWC/Aura)
- Security scanning
- Test coverage checks
- Quality gate validation

**No secrets required** - runs static analysis only

---

## Setting Up Secrets

### Step 1: Get Salesforce Auth URL

For each org (Dev, UAT, Production):

```bash
# Authenticate to your org
sf org login web --alias my-org --instance-url https://test.salesforce.com

# Display auth URL
sf org display --target-org my-org --verbose

# Copy the "Sfdx Auth Url" value
```

### Step 2: Add Secrets to GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these secrets:
   - `SF_AUTH_URL` - For PR validation (can use dev sandbox)
   - `SF_DEV_AUTH_URL` - For dev sandbox deployments
   - `SF_UAT_AUTH_URL` - For UAT validation
   - `SF_PROD_AUTH_URL` - For production deployments

---

## Setting Up Environments

### Create GitHub Environments for Manual Approvals

1. Go to **Settings** → **Environments**
2. Create these environments:
   - `dev` - No protection rules needed
   - `uat` - Add reviewers if desired
   - `production` - **Add required reviewers** (critical!)

3. For **production** environment:
   - Click on environment → **Add protection rules**
   - Enable **Required reviewers**
   - Add at least 1-2 reviewers who must approve before deployment

---

## Branch Protection Rules

Set up branch protection for `main` and `develop`:

1. Go to **Settings** → **Branches**
2. Click **Add rule**
3. For `main` branch:
   - Branch name pattern: `main`
   - ✅ Require a pull request before merging
   - ✅ Require approvals (1+)
   - ✅ Require status checks to pass
   - Select: `Validate Metadata`, `Code Quality Checks`
   - ✅ Require branches to be up to date
   - ✅ Do not allow bypassing the above settings

4. Repeat for `develop` branch

---

## Testing the Workflows

### Test PR Validation
```bash
# Create a feature branch
git checkout -b feature/test-workflow

# Make a change
echo "// test" >> force-app/main/default/classes/AccountService.cls

# Commit and push
git add .
git commit -m "test: trigger workflow"
git push origin feature/test-workflow

# Create a PR on GitHub targeting develop
```

### Test Code Quality
The workflow runs automatically on push to any branch.

### Test Deployment (without org connection)
```bash
# Push to develop
git checkout develop
git merge feature/test-workflow
git push origin develop

# The workflow will run but skip deployment steps if secrets aren't set
```

---

## Workflow Status Badges

Add these badges to your main README.md:

```markdown
![PR Validation](https://github.com/USERNAME/salesforce-devops-practice/actions/workflows/pr-validation.yml/badge.svg)
![Code Quality](https://github.com/USERNAME/salesforce-devops-practice/actions/workflows/code-quality.yml/badge.svg)
![Deploy to Dev](https://github.com/USERNAME/salesforce-devops-practice/actions/workflows/deploy-to-dev.yml/badge.svg)
```

---

## Troubleshooting

### "SF_AUTH_URL secret not found"
- Make sure you've added the secret in GitHub Settings → Secrets
- Check the secret name matches exactly (case-sensitive)

### "Authentication failed"
- Regenerate the auth URL: `sf org display --target-org my-org --verbose`
- Make sure the auth URL includes the full string with `force://`

### "Deployment validation failed"
- Check the deployment error in the workflow logs
- Run validation locally: `sf project deploy validate --target-org my-org`

### Manual workflow run
To manually trigger a workflow:
1. Go to **Actions** tab
2. Select the workflow
3. Click **Run workflow**
4. Choose branch and click **Run workflow**

---

## Best Practices

1. **Always validate before deploying** - Don't skip the check-only step
2. **Use environments for production** - Require manual approval
3. **Monitor workflow failures** - Set up notifications
4. **Keep auth URLs secure** - Never commit them to the repository
5. **Rotate credentials regularly** - Update secrets every 90 days
6. **Test in lower environments first** - Dev → UAT → Production
