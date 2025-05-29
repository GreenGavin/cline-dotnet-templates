# User Guide: GitHub Automation with Cline Templates

> **Note**: This guide is automatically saved to `.cline/documentation/github-automation-guide.md` for easy reference.

## Overview
This guide shows you how to use Cline to automatically create GitHub issues, tasks, and project management based on your downloaded template files.

## Prerequisites Setup

### 1. Enable GitHub MCP Server
- Open Cline settings in VS Code
- Go to MCP Servers section
- Add GitHub MCP server
- Configure with your GitHub Personal Access Token (needs repo permissions)

### 2. Ensure Templates Are Downloaded
- Run your custom instruction to download templates to `.cline/` directory
- Verify you have: `instructions.md`, `git-workflow.md`, `github-integration.md`, issue templates

## What You Can Ask Cline To Do

### 🎯 Create Project Issues
**Simple Request:**
```
"Cline, create GitHub issues for this project based on our .cline/instructions.md file. Use our issue templates."
```

**Detailed Request:**
```
"Read our .cline/instructions.md and create GitHub issues for each major feature. Use our feature-request.md template and add appropriate labels and milestones."
```

### 📋 Set Up Project Board
```
"Create a GitHub project board with columns for Backlog, In Progress, Review, and Done. Add all our project issues to the Backlog column."
```

### 🔐 Security-Focused Issues
```
"Review our .cline/security-notes.md and create GitHub issues for all security requirements. Mark them as high priority and use our security-issue template."
```

### 🚀 Development Workflow Setup
```
"Based on our .cline/git-workflow.md, create GitHub Actions workflows for CI/CD, testing, and deployment."
```

### 📊 Complete Project Setup
```
"Set up our entire GitHub project infrastructure based on all templates in .cline/ directory. Include issues, project board, workflows, and repository settings."
```

## Tips for Better Results

### Be Specific About Templates
- ✅ "Use our feature-request.md template"
- ✅ "Follow the format in .cline/templates/issue-templates/"
- ❌ "Create some issues"

### Reference Your Files
- ✅ "Based on requirements in .cline/instructions.md"
- ✅ "Following the workflow in .cline/git-workflow.md"
- ❌ "Create issues for the project"

### Start Small, Then Scale
1. First: "Create 3 GitHub issues for our main features"
2. Review the results
3. Then: "Create issues for all remaining features"

## Common Commands

### Issue Creation
| What You Want | What To Say |
|---------------|-------------|
| Feature issues | "Create GitHub issues for each feature in .cline/instructions.md using our feature-request template" |
| Bug tracking | "Set up bug tracking issues using our bug-report.md template" |
| Security tasks | "Create security issues from .cline/security-notes.md with high priority" |

### Project Management
| What You Want | What To Say |
|---------------|-------------|
| Project board | "Create a GitHub project board with our standard columns and add all issues" |
| Milestones | "Create milestones based on the phases mentioned in .cline/instructions.md" |
| Labels | "Set up GitHub labels for features, bugs, security, and documentation" |

### Automation
| What You Want | What To Say |
|---------------|-------------|
| CI/CD | "Create GitHub Actions workflows based on .cline/git-workflow.md" |
| Issue automation | "Set up automated issue labeling and assignment rules" |
| Security scanning | "Add security scanning workflows based on .cline/security-notes.md" |

## Advanced Usage

### Bulk Operations
```
"Process all our template files and create a complete GitHub project setup:
1. Issues from instructions.md 
2. Project board with automation
3. CI/CD workflows from git-workflow.md
4. Security configurations from security-notes.md"
```

### Integration with Development
```
"Create GitHub issues and then create corresponding feature branches for each issue following our git-workflow.md branching strategy."
```

### Documentation Updates
```
"Create GitHub issues for updating documentation and README files based on our project templates."
```

## Troubleshooting

### If Cline Can't Access GitHub
- Check MCP server configuration
- Verify GitHub token permissions
- Ensure repository access is granted

### If Issues Aren't Formatted Correctly
- Be more specific about which template to use
- Ask Cline to "show me an example first"
- Reference specific template files

### If Too Many Issues Created
- Start with "Create 3 example issues first"
- Review and refine the approach
- Then ask for bulk creation

## Example Session

```
You: "Cline, I want to set up GitHub issues for my new project. Start by reading .cline/instructions.md and create 5 main feature issues using our feature-request.md template."

Cline: [Creates 5 issues with proper formatting]

You: "Great! Now create a project board and add these issues to the Backlog column."

Cline: [Sets up project board]

You: "Perfect. Now create GitHub Actions workflows based on our .cline/git-workflow.md for CI/CD."

Cline: [Creates workflow files]
```

## Benefits
- ✅ Consistent issue formatting using your templates
- ✅ Automated project setup based on your workflows
- ✅ Security considerations built-in
- ✅ Saves hours of manual GitHub configuration
- ✅ Follows your established processes and standards