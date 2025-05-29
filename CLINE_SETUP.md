# Cline Auto-Setup Instructions for .NET Projects

## Directory Structure to Create
1. Create `.cline/` directory
2. Create `.cline/templates/` directory  
3. Create `.cline/templates/issue-templates/` directory

## Files to Download (in order)
1. `templates/instructions.md` → `.cline/instructions.md`
2. `templates/git-workflow.md` → `.cline/git-workflow.md`
3. `templates/github-integration.md` → `.cline/github-integration.md`
4. `templates/security-notes.md` → `.cline/security-notes.md`
5. `templates/issue-templates/bug-report.md` → `.cline/templates/issue-templates/bug-report.md`
6. `templates/issue-templates/feature-request.md` → `.cline/templates/issue-templates/feature-request.md`
7. `templates/issue-templates/security-issue.md` → `.cline/templates/issue-templates/security-issue.md`

## Context Files to Create (if they don't exist)
- `.cline/context.md` - Current project state and recent progress
- `.cline/tasks.md` - Development tasks and priorities  
- `.cline/decisions.md` - Architecture decision records
- `.cline/TEMPLATE_VERSION` - Save current template version from VERSION file

## Error Handling
- Create each directory individually before downloading files
- Report success/failure for each file download
- Continue with other downloads even if some fail
- Use existing local templates if downloads fail