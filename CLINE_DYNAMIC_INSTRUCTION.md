# Cline Dynamic Templates

## Template Repositories
- **.NET Projects**: `https://raw.githubusercontent.com/GreenGavin/cline-dotnet-templates/main`
- **Cross-Platform Projects**: `https://raw.githubusercontent.com/GreenGavin/cline-crossplatform-templates/main`

## Automatic Setup (Every Session Start)

### 1. Detect Project Type
- **Look for**: `.sln`, `.csproj`, `Program.cs` → .NET project
- **Look for**: `package.json` with React Native/Electron → Cross-platform project  
- **Default**: .NET if unclear

### 2. Download Templates (If Missing or Outdated)
**Create `.cline/` directory and download these files:**

**For .NET Projects:**
- `templates/instructions.md` → `.cline/instructions.md`
- `templates/git-workflow.md` → `.cline/git-workflow.md`
- `templates/github-integration.md` → `.cline/github-integration.md`
- `templates/security-notes.md` → `.cline/security-notes.md`
- Issue templates to `.cline/templates/issue-templates/`

**For Cross-Platform Projects:**
- Same files, plus performance issue template

### 3. Check for Updates
- Compare remote `VERSION` file with local `.cline/TEMPLATE_VERSION`
- If newer version available, re-download templates
- Show release notes from `RELEASE_NOTES.md` if available

### 4. Follow Downloaded Instructions
**Priority order:**
1. **`.cline/instructions.md`** (project-specific guidelines) - **HIGHEST**
2. **`.cline/context.md`** (current project state)
3. **`.cline/tasks.md`** (active development tasks)
4. **Other `.cline/` files** as needed

## What You Do
- Read ALL downloaded `.cline/` files at session start
- Follow the professional development guidelines from templates
- Update `.cline/context.md` and `.cline/tasks.md` as you work
- Use templates for consistent, professional development practices

## Error Handling
- If download fails: Use existing local templates
- If no templates exist: Continue with basic best practices
- Always maintain development productivity
