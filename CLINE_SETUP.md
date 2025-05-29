# Cline Auto-Setup Instructions for .NET Projects

## Initial Setup vs Update Detection
1. Check if `.cline/documentation/TEMPLATE_VERSION` exists
2. If exists: Compare with remote VERSION to determine if update needed
3. If no version file or versions differ: Proceed with setup/update process

## Directory Structure to Create
1. Create `.cline/` directory
2. Create `.cline/templates/` directory  
3. Create `.cline/templates/issue-templates/` directory
4. Create `.cline/backups/` directory (for version management)
5. Create `.cline/documentation/` directory (for version tracking and user guides)

## Version Management Files
- `.cline/documentation/file-hashes.json` - Track original template file hashes
- `.cline/documentation/user-modifications.json` - Track which files user has modified
- `.cline/documentation/TEMPLATE_VERSION` - Current template version
- `.cline/documentation/github-automation-guide.md` - User guide for GitHub automation
- `.cline/documentation/setup-log.txt` - Setup and update logs

## Update Process (when version differs)
1. **Pre-Update Backup**
   - Create backup directory: `.cline/backups/backup-[current-version]-[timestamp]/`
   - Copy all current `.cline/` files to backup directory
   - Log backup location for user reference

2. **Change Detection**
   - Read `.cline/documentation/file-hashes.json` to get original template hashes
   - Calculate current file hashes and compare
   - Mark files as "user-modified" if hashes don't match originals
   - Store user modifications in `.cline/documentation/user-modifications.json`

3. **Smart Update Strategy**
   - Download new templates to temporary location first
   - For each file to update:
     - **If file not user-modified**: Auto-update and inform user
     - **If file user-modified**: 
       - Show file path and ask: "File [filename] has local changes. Options: (k)eep current, (u)pdate anyway, (s)how diff"
       - If user chooses show diff: Display key changes between versions
       - Respect user choice and log decision

## Files to Download/Update (in order)
1. `templates/instructions.md` → `.cline/instructions.md`
2. `templates/git-workflow.md` → `.cline/git-workflow.md`
3. `templates/github-integration.md` → `.cline/github-integration.md`
4. `templates/security-notes.md` → `.cline/security-notes.md`
5. `templates/issue-templates/bug-report.md` → `.cline/templates/issue-templates/bug-report.md`
6. `templates/issue-templates/feature-request.md` → `.cline/templates/issue-templates/feature-request.md`
7. `templates/issue-templates/security-issue.md` → `.cline/templates/issue-templates/security-issue.md`

## Hash Tracking (after each file download/update)
- Calculate SHA-256 hash of downloaded file
- Store in `.cline/documentation/file-hashes.json` format:
```json
{
  "instructions.md": "abc123...",
  "git-workflow.md": "def456...",
  "last_updated": "2025-05-29T10:30:00Z"
}
```

## Additional Files to Create
- `.cline/documentation/github-automation-guide.md` - Copy the GitHub automation user guide
- Download GitHub automation guide from templates repository if available

## Context Files to Create (if they don't exist)
- `.cline/context.md` - Current project state and recent progress
- `.cline/tasks.md` - Development tasks and priorities  
- `.cline/decisions.md` - Architecture decision records

## Error Handling
- Create each directory individually before downloading files
- Report success/failure for each file download
- Continue with other downloads even if some fail
- Use existing local templates if downloads fail
- If backup creation fails, warn user and ask if they want to continue
- Log all errors to `.cline/documentation/setup-log.txt` with timestamps

## Post Setup/Update
- Edit the `.cline/instructions.md` and update [Solution Name] with the correct project name (only if file was updated or newly created)
- If `.cline/instructions.md` was user-modified, prompt: "Instructions file has local changes. Would you like me to help merge the project name update?"
- Edit `.cline/context.md` and update with current project knowledge
- Edit `.cline/tasks.md` and update with current development status
- Update `.cline/documentation/TEMPLATE_VERSION` to match remote version
- **IMPORTANT: After setup/update completion, read and follow `.cline/instructions.md` for all development work**
- Display summary of what was updated vs what was preserved

## Development Guidelines
- **Always read `.cline/instructions.md` at the start of any development task**
- Follow all guidelines, workflows, and standards specified in the instructions
- The instructions.md file will reference other relevant files (git-workflow.md, security-notes.md, etc.) as needed
- Use the downloaded templates for consistency in issues, documentation, and code structure

## Update Summary Report
After completion, show:
```
Setup/Update Complete!
- Template Version: [old] → [new]
- Files Updated: [list]
- Files Preserved (user-modified): [list]  
- Backup Location: .cline/backups/backup-[version]-[timestamp]/
- Next: Review updated files and merge any needed customizations
```

## Final Verification & Missing File Recovery
After all downloads complete, verify these critical files exist and download if missing:

### Required Documentation Files Check
1. **Check `.cline/documentation/github-automation-guide.md`**
   - If missing: Download from `templates/documentation/github-automation-guide.md`
   - If template repository doesn't have it: Create basic version with placeholder content
   - Log: "GitHub automation guide downloaded/created"

2. **Check `.cline/documentation/TEMPLATE_VERSION`**
   - If missing: Create with current version number
   - Log: "Template version file created"

3. **Check `.cline/documentation/file-hashes.json`**
   - If missing: Calculate hashes for all current files and create
   - Log: "File hash tracking initialized"

### Recovery Download Process
For any missing documentation file:
```bash
# Try primary template location first
templates/documentation/[filename] → .cline/documentation/[filename]

# If not found, try fallback locations:
templates/[filename] → .cline/documentation/[filename]
docs/[filename] → .cline/documentation/[filename]

# If still not found, create basic placeholder with note:
"This file was not found in template repository. Please update manually."
```

### Verification Report
Show final verification status:
```
Final Verification Complete!
✅ Core templates: [count] files verified
✅ Issue templates: [count] files verified  
✅ Documentation files: [count] files verified
⚠️  Missing files created as placeholders: [list if any]
🔄 Files needing manual review: [list if any]
```