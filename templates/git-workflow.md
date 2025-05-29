# Git Workflow for .NET Projects

## Branch Strategy

### Main Branches
- **main**: Production-ready code, protected branch
- **develop**: Integration branch for features, auto-deploys to staging
- **release/x.x.x**: Release preparation branches
- **hotfix/**: Critical production fixes

### Feature Branches
- **feature/**: New features and enhancements
- **bugfix/**: Non-critical bug fixes
- **chore/**: Maintenance tasks (dependencies, refactoring)

### Branch Naming Convention
```
feature/JIRA-123-user-authentication
bugfix/JIRA-456-fix-null-reference
hotfix/JIRA-789-critical-security-fix
chore/update-dependencies
release/v2.1.0
```

## Commit Message Standards

### Conventional Commits Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Commit Types
- **feat**: New feature for the user
- **fix**: Bug fix for the user
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring without changing functionality
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Build process, dependency updates, or tooling changes
- **ci**: CI/CD configuration changes
- **security**: Security-related changes

### Scope Examples for .NET
- **api**: Web API changes
- **auth**: Authentication/authorization
- **db**: Database related changes
- **ui**: User interface changes
- **tests**: Test-related changes
- **config**: Configuration changes

### Commit Message Examples
```bash
feat(auth): add JWT token refresh mechanism
fix(api): resolve null reference exception in user controller
docs(readme): update installation instructions
refactor(services): extract user validation logic
perf(db): optimize user query with proper indexing
test(auth): add unit tests for login service
chore(deps): update Entity Framework to version 8.0.1
security(api): implement rate limiting for authentication endpoints
```

## Pull Request Guidelines

### PR Requirements
- [ ] Branch is up to date with target branch
- [ ] All tests pass locally
- [ ] Code follows project style guidelines
- [ ] Security considerations reviewed
- [ ] Performance impact assessed
- [ ] Documentation updated if needed
- [ ] Breaking changes documented

### PR Template
```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Security enhancement

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] Performance tested (if applicable)

## Security Checklist
- [ ] Input validation implemented
- [ ] Authentication/authorization verified
- [ ] No sensitive data exposed
- [ ] SQL injection prevention verified
- [ ] XSS prevention implemented

## Related Issues
Closes #123
Relates to #456

## Breaking Changes
None / [Describe breaking changes]

## Screenshots (if applicable)
[Add screenshots for UI changes]
```

### Code Review Checklist
- [ ] Code follows SOLID principles
- [ ] Proper error handling implemented
- [ ] Security best practices followed
- [ ] Performance considerations addressed
- [ ] Tests cover new functionality
- [ ] Documentation is clear and accurate
- [ ] No hardcoded secrets or sensitive data
- [ ] Logging is appropriate and secure

## Git Workflow Process

### Starting New Work
```bash
# Start from develop branch
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/JIRA-123-user-authentication

# Work on feature...
git add .
git commit -m "feat(auth): add initial user authentication structure"

# Push feature branch
git push -u origin feature/JIRA-123-user-authentication
```

### During Development
```bash
# Regular commits with conventional format
git add .
git commit -m "feat(auth): implement JWT token generation"

# Keep branch updated with develop
git checkout develop
git pull origin develop
git checkout feature/JIRA-123-user-authentication
git rebase develop

# Push updates
git push origin feature/JIRA-123-user-authentication
```

### Creating Pull Request
```bash
# Ensure branch is ready
git checkout feature/JIRA-123-user-authentication
git rebase develop
git push origin feature/JIRA-123-user-authentication

# Create PR via GitHub CLI or web interface
gh pr create --title "feat(auth): implement user authentication system" \
  --body "Implements JWT-based authentication with refresh tokens. Closes #123" \
  --base develop \
  --head feature/JIRA-123-user-authentication
```

### Hotfix Process
```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/JIRA-789-security-fix

# Make critical fix
git add .
git commit -m "security(api): fix authentication bypass vulnerability"

# Create PR to main
gh pr create --title "security(api): fix authentication bypass" \
  --body "Critical security fix for authentication. Resolves #789" \
  --base main \
  --head hotfix/JIRA-789-security-fix

# Also merge back to develop
git checkout develop
git merge hotfix/JIRA-789-security-fix
git push origin develop
```

## Release Process

### Creating Release Branch
```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v2.1.0

# Update version numbers, changelog, etc.
git add .
git commit -m "chore(release): prepare version 2.1.0"
git push -u origin release/v2.1.0
```

### Finalizing Release
```bash
# Merge to main
git checkout main
git merge release/v2.1.0
git tag -a v2.1.0 -m "Release version 2.1.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge release/v2.1.0
git push origin develop

# Delete release branch
git branch -d release/v2.1.0
git push origin --delete release/v2.1.0
```

## Git Hooks

### Pre-commit Hook Example
```bash
#!/bin/sh
# Run tests before commit
dotnet test --no-build --verbosity quiet
if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

# Run code formatting
dotnet format --no-restore --verify-no-changes
if [ $? -ne 0 ]; then
  echo "Code not properly formatted. Run 'dotnet format' and try again."
  exit 1
fi
```

### Commit Message Hook
```bash
#!/bin/sh
# Validate commit message format
commit_regex='^(feat|fix|docs|style|refactor|perf|test|chore|ci|security)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
  echo "Invalid commit message format!"
  echo "Use: <type>(<scope>): <description>"
  echo "Example: feat(auth): add user login functionality"
  exit 1
fi
```

## Issue Linking

### Automatic Issue Closing
Use these keywords in commit messages or PR descriptions:
- `closes #123` or `fixes #123` - Closes the issue
- `resolves #123` - Resolves the issue
- `relates to #123` - Links but doesn't close

### Branch to Issue Linking
- Include issue number in branch name: `feature/JIRA-123-description`
- Reference in all related commits
- Link in PR description