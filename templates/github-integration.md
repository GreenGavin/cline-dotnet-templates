# GitHub Integration Guidelines for .NET Projects

## Setup Requirements

### Prerequisites
1. **Install GitHub CLI**: 
   ```powershell
   winget install GitHub.cli
   ```
2. **Authenticate**: 
   ```bash
   gh auth login
   ```
3. **Set repository context**: 
   ```bash
   gh repo set-default
   ```
4. **Verify setup**:
   ```bash
   gh repo view
   ```

### Repository Configuration
```bash
# Enable GitHub features
gh repo edit --enable-issues --enable-projects --enable-wiki
gh repo edit --default-branch main

# Set branch protection rules
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["build","test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}'
```

## Issue Management

### Creating Issues with Templates

#### Bug Reports
```bash
# Create bug report using template
gh issue create \
  --title "Bug: [Brief Description]" \
  --body-file .cline/templates/issue-templates/bug-report.md \
  --label "bug,needs-triage" \
  --assignee @me

# Quick bug report
gh issue create \
  --title "Bug: Null reference exception in UserController" \
  --body "Exception occurs when accessing /api/users/{id} with invalid ID" \
  --label "bug,api,high-priority"
```

#### Feature Requests
```bash
# Create feature request
gh issue create \
  --title "Feature: Add JWT refresh token support" \
  --body-file .cline/templates/issue-templates/feature-request.md \
  --label "enhancement,authentication"

# Epic for large features
gh issue create \
  --title "Epic: User Management System" \
  --body "Track all user management related features and improvements" \
  --label "epic,enhancement"
```

#### Security Issues
```bash
# Create security issue (private)
gh issue create \
  --title "Security: Authentication bypass vulnerability" \
  --body-file .cline/templates/issue-templates/security-issue.md \
  --label "security,critical,needs-review" \
  --assignee security-team

# Note: For sensitive security issues, consider using GitHub Security Advisories
gh api repos/{owner}/{repo}/security-advisories \
  --method POST \
  --field summary="Authentication bypass in login endpoint" \
  --field description="Detailed security issue description"
```

### Issue Management Commands

#### Listing and Searching Issues
```bash
# List open issues
gh issue list --state open --limit 20

# Search issues by label
gh issue list --label "bug" --state open
gh issue list --label "enhancement,needs-review"

# Search by text
gh issue list --search "authentication" --state all
gh issue list --search "bug in:title" --state open

# Filter by assignee
gh issue list --assignee @me
gh issue list --assignee username
```

#### Updating Issues
```bash
# View issue details
gh issue view 123
gh issue view 123 --web

# Edit issue
gh issue edit 123 --title "Updated: Better title"
gh issue edit 123 --body "Updated description"
gh issue edit 123 --add-label "in-progress"
gh issue edit 123 --remove-label "needs-triage"

# Add comments
gh issue comment 123 --body "Working on this issue now. ETA: 2 days"
gh issue comment 123 --body "Fixed in commit abc123. Ready for testing."

# Assign issues
gh issue edit 123 --assignee username
gh issue edit 123 --assignee @me

# Close issues
gh issue close 123 --comment "Fixed in PR #456"
gh issue close 123 --reason "not planned"
```

#### Bulk Operations
```bash
# Close multiple issues
gh issue list --label "duplicate" --json number --jq '.[].number' | \
  xargs -I {} gh issue close {} --reason "not planned"

# Add label to multiple issues
gh issue list --search "authentication" --json number --jq '.[].number' | \
  xargs -I {} gh issue edit {} --add-label "auth"
```

## Pull Request Management

### Creating Pull Requests
```bash
# Create PR with template
gh pr create \
  --title "feat(auth): implement JWT refresh tokens" \
  --body "Implements JWT refresh token functionality. Closes #123" \
  --base develop \
  --head feature/jwt-refresh-tokens \
  --reviewer @teammate1,@teammate2 \
  --label "enhancement,authentication"

# Draft PR for work in progress
gh pr create \
  --title "WIP: User management refactoring" \
  --body "Work in progress - refactoring user management code" \
  --draft \
  --label "work-in-progress"

# PR with auto-merge (after reviews)
gh pr create \
  --title "chore: update dependencies" \
  --body "Updates all NuGet packages to latest versions" \
  --auto-merge
```

### PR Review Process
```bash
# List PRs for review
gh pr list --search "review-requested:@me"
gh pr list --label "needs-review"

# Review PR
gh pr view 456
gh pr review 456 --approve --body "LGTM! Great work on the implementation."
gh pr review 456 --request-changes --body "Please address the security concerns in AuthController"
gh pr review 456 --comment --body "Nice refactoring! A few minor comments."

# Check PR status
gh pr status
gh pr checks 456
```

### Merging and Cleanup
```bash
# Merge PR (after approval)
gh pr merge 456 --squash --delete-branch
gh pr merge 456 --merge
gh pr merge 456 --rebase

# Auto-merge when ready
gh pr merge 456 --auto --squash --delete-branch
```

## Project Management Integration

### GitHub Projects (Beta)
```bash
# List projects
gh project list --owner organization-name

# Add issue to project
gh project item-add PROJECT_NUMBER --owner OWNER --item-id ISSUE_NUMBER

# Update project item status
gh project item-edit --id ITEM_ID --field-id FIELD_ID --text "In Progress"
```

### Milestones
```bash
# Create milestone
gh api repos/{owner}/{repo}/milestones \
  --method POST \
  --field title="v2.1.0 Release" \
  --field description="Features and fixes for version 2.1.0" \
  --field due_on="2024-03-01T00:00:00Z"

# Add issue to milestone
gh issue edit 123 --milestone "v2.1.0 Release"

# List milestone progress
gh api repos/{owner}/{repo}/milestones | jq '.[] | {title, open_issues, closed_issues}'
```

## Automated Workflows

### Issue Automation
```bash
# Create issue for failed builds
create_build_issue() {
    gh issue create \
      --title "Build: CI/CD pipeline failed on $(date)" \
      --body "Automated issue: Build pipeline failed. Check logs and fix." \
      --label "ci-cd,bug,automated"
}

# Auto-assign issues based on labels
auto_assign_issue() {
    local issue_number=$1
    local labels=$(gh issue view $issue_number --json labels --jq '.labels[].name')
    
    if [[ $labels == *"database"* ]]; then
        gh issue edit $issue_number --assignee database-team
    elif [[ $labels == *"frontend"* ]]; then
        gh issue edit $issue_number --assignee frontend-team
    fi
}
```

### Development Workflow Integration
```bash
# Start work on issue
start_issue_work() {
    local issue_number=$1
    local issue_title=$(gh issue view $issue_number --json title --jq '.title')
    local branch_name="feature/issue-${issue_number}-$(echo $issue_title | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]')"
    
    # Create branch
    git checkout -b $branch_name
    
    # Update issue status
    gh issue edit $issue_number --add-label "in-progress"
    gh issue comment $issue_number --body "Started working on this issue in branch: $branch_name"
}

# Complete issue work
complete_issue_work() {
    local issue_number=$1
    local branch_name=$(git branch --show-current)
    
    # Create PR
    gh pr create \
      --title "fix: resolve issue #${issue_number}" \
      --body "Closes #${issue_number}" \
      --label "bug-fix"
    
    # Update issue
    gh issue edit $issue_number --add-label "ready-for-review"
}
```

## Repository Analytics

### Issue Analytics
```bash
# Issues by label
gh issue list --state all --json labels,state | \
  jq -r '.[] | .labels[].name' | sort | uniq -c | sort -nr

# Issues by assignee
gh issue list --state open --json assignees | \
  jq -r '.[] | .assignees[].login' | sort | uniq -c | sort -nr

# Issue age analysis
gh issue list --state open --json createdAt,number,title | \
  jq -r '.[] | "\(.number): \(.title) (\(.createdAt))"'
```

### PR Analytics
```bash
# PR review statistics
gh pr list --state merged --limit 50 --json reviews,number | \
  jq '.[] | {number, review_count: (.reviews | length)}'

# Time to merge analysis
gh pr list --state merged --limit 20 --json number,createdAt,mergedAt | \
  jq '.[] | {number, days_to_merge: (((.mergedAt | strptime("%Y-%m-%dT%H:%M:%SZ") | mktime) - (.createdAt | strptime("%Y-%m-%dT%H:%M:%SZ") | mktime)) / 86400 | floor)}'
```

## Security Integration

### Security Advisories
```bash
# List security advisories
gh api repos/{owner}/{repo}/security-advisories

# Create security advisory
gh api repos/{owner}/{repo}/security-advisories \
  --method POST \
  --field summary="SQL Injection in User Controller" \
  --field description="Detailed description of the vulnerability"
```

### Dependency Management
```bash
# Check for security vulnerabilities
gh api repos/{owner}/{repo}/vulnerability-alerts

# Enable dependency graph and security alerts
gh api repos/{owner}/{repo} \
  --method PATCH \
  --field has_vulnerability_alerts=true
```

## Best Practices

### Issue Labeling Strategy
- **Type**: `bug`, `enhancement`, `documentation`, `question`
- **Priority**: `critical`, `high-priority`, `medium-priority`, `low-priority`
- **Status**: `needs-triage`, `in-progress`, `blocked`, `ready-for-review`
- **Component**: `api`, `database`, `frontend`, `authentication`, `testing`
- **Size**: `small`, `medium`, `large`, `epic`

### Automation Rules
1. **Auto-assign** issues based on labels and file paths
2. **Auto-label** PRs based on changed files
3. **Auto-close** issues when related PRs are merged
4. **Auto-create** issues for failed builds or security alerts
5. **Auto-update** project boards when issue status changes

### Communication Standards
- **Issue titles**: Clear, descriptive, include type prefix
- **PR descriptions**: Link to issues, explain changes, include testing notes
- **Comments**: Professional, helpful, include next steps
- **Labels**: Consistent application across team
- **Assignees**: Clear ownership and responsibility

Remember: Effective GitHub integration requires consistent usage across the team and proper automation to reduce manual overhead.