# Universal Dynamic Cline Instructions with Remote Templates

## Template Repository Configuration

### Default Template Repositories
- **For .NET Projects**: `https://raw.githubusercontent.com/GreenGavin/cline-dotnet-templates/main`
- **For Cross-Platform Projects**: `https://raw.githubusercontent.com/GreenGavin/cline-crossplatform-templates/main`

### Environment Variables (Optional Override)
```bash
# Override default template repositories
export CLINE_DOTNET_TEMPLATES_REPO="https://raw.githubusercontent.com/your-org/dotnet-templates/main"
export CLINE_CROSSPLATFORM_TEMPLATES_REPO="https://raw.githubusercontent.com/your-org/crossplatform-templates/main"

# Disable auto-updates (default: enabled)
export CLINE_AUTO_UPDATE_TEMPLATES=false

# Custom GitHub token for private repos
export CLINE_GITHUB_TOKEN="ghp_your_token_here"
```

## Dynamic Instruction Loading Protocol

### Primary Instructions Source
1. **Check for `.cline/instructions.md`** in project root directory
2. **If exists**: Read and follow ALL guidelines from that file as the primary instruction set
3. **If missing**: Detect project type and download appropriate templates from remote repository

### Project Type Detection
Automatically detect project type based on files present in the current directory:

#### .NET Project Detection
**Look for any of these indicators:**
- `*.sln` files (Visual Studio solution)
- `*.csproj` files (C# project files)
- `Program.cs` or `Startup.cs` files
- `appsettings.json` configuration files
- `Directory.Build.props` or `Directory.Packages.props`
- Folders named `src`, `tests`, or `docs` with .NET structure

**If detected**: Use .NET template repository

#### Cross-Platform Project Detection  
**Look for any of these indicators:**
- `package.json` with React Native dependencies
- `electron/` directory with Electron files
- `src/platforms/` directory structure
- React Native configuration files (`metro.config.js`, `react-native.config.js`)
- TypeScript config with React Native types
- Folders indicating cross-platform structure (`src/core/`, `src/services/`, `src/components/`)

**If detected**: Use Cross-Platform template repository

#### Default Behavior
**If no specific project type detected**: Use .NET templates as default fallback

### Template Download and Setup Process

### Template Download and Setup Process

### Template Download and Setup Process

#### Step 1: Check for Template Updates
When starting a session, Cline should automatically execute this process:

```javascript
// Cross-platform template initialization process
async function initializeTemplates() {
  console.log("🔄 Initializing Cline templates...");
  
  const projectType = detectProjectType();
  console.log(`📁 Detected project type: ${projectType}`);
  
  const templateRepo = projectType === 'dotnet' 
    ? 'https://raw.githubusercontent.com/GreenGavin/cline-dotnet-templates/main'
    : 'https://raw.githubusercontent.com/GreenGavin/cline-crossplatform-templates/main';
  
  try {
    // Check if .cline directory exists (cross-platform path handling)
    const clineDir = '.cline';
    const templatesDir = path.join(clineDir, 'templates');
    const issueTemplatesDir = path.join(templatesDir, 'issue-templates');
    
    if (!directoryExists(clineDir)) {
      console.log("📁 Creating .cline directory...");
      createDirectoryRecursive(clineDir);
      createDirectoryRecursive(templatesDir);
      createDirectoryRecursive(issueTemplatesDir);
    }

    // Check local version (cross-platform file reading)
    const versionFile = path.join(clineDir, 'TEMPLATE_VERSION');
    const localVersion = fileExists(versionFile) ? readFile(versionFile).trim() : '0.0.0';
    
    // Check remote version
    const remoteVersionUrl = `${templateRepo}/VERSION`;
    const remoteVersion = (await fetchContent(remoteVersionUrl)).trim();
    
    if (compareVersions(remoteVersion, localVersion) > 0 || localVersion === '0.0.0') {
      console.log(`📡 Template update available: ${localVersion} → ${remoteVersion}`);
      
      // Show release notes if available
      try {
        const releaseNotes = await fetchContent(`${templateRepo}/RELEASE_NOTES.md`);
        console.log("\n" + "=".repeat(60));
        console.log("🆕 WHAT'S NEW IN THIS UPDATE:");
        console.log("=".repeat(60));
        console.log(releaseNotes);
        console.log("=".repeat(60) + "\n");
      } catch (error) {
        console.log("📋 Release notes not available");
      }
      
      console.log("⬇️ Downloading templates...");
      await downloadAllTemplates(templateRepo, projectType);
      
      // Save version (cross-platform file writing)
      writeFile(versionFile, remoteVersion);
      console.log(`✅ Templates updated to version ${remoteVersion}`);
    } else {
      console.log(`✅ Templates are up to date (v${localVersion})`);
    }
  } catch (error) {
    console.log(`⚠️ Could not check for template updates: ${error.message}`);
    console.log(`📁 Using existing local templates or creating basic ones`);
    
    // Create basic templates if none exist
    const instructionsFile = path.join('.cline', 'instructions.md');
    if (!fileExists(instructionsFile)) {
      await createBasicTemplates(projectType);
    }
  }
}

// Cross-platform helper functions
function createDirectoryRecursive(dirPath) {
  // Handle both Windows and Unix-style paths
  const normalizedPath = path.normalize(dirPath);
  if (!directoryExists(normalizedPath)) {
    // Create directory recursively
    const parts = normalizedPath.split(path.sep);
    let currentPath = '';
    
    for (const part of parts) {
      currentPath = currentPath ? path.join(currentPath, part) : part;
      if (currentPath && !directoryExists(currentPath)) {
        createDirectory(currentPath);
      }
    }
  }
}

function normalizeLineEndings(content) {
  // Normalize line endings for cross-platform compatibility
  return content.replace(/\r\n/g, '\n').replace(/\r/g, '\n');
}

// This function should run automatically when Cline starts
initializeTemplates();
```

#### Step 2: Cross-Platform Template Download
The following templates should be downloaded with proper path handling:

**For .NET Projects:**
```javascript
const dotnetTemplateFiles = [
  { remote: 'templates/instructions.md', local: path.join('.cline', 'instructions.md') },
  { remote: 'templates/git-workflow.md', local: path.join('.cline', 'git-workflow.md') },
  { remote: 'templates/github-integration.md', local: path.join('.cline', 'github-integration.md') },
  { remote: 'templates/security-notes.md', local: path.join('.cline', 'security-notes.md') },
  { remote: 'templates/issue-templates/bug-report.md', local: path.join('.cline', 'templates', 'issue-templates', 'bug-report.md') },
  { remote: 'templates/issue-templates/feature-request.md', local: path.join('.cline', 'templates', 'issue-templates', 'feature-request.md') },
  { remote: 'templates/issue-templates/security-issue.md', local: path.join('.cline', 'templates', 'issue-templates', 'security-issue.md') }
];

const crossPlatformTemplateFiles = [
  { remote: 'templates/instructions.md', local: path.join('.cline', 'instructions.md') },
  { remote: 'templates/git-workflow.md', local: path.join('.cline', 'git-workflow.md') },
  { remote: 'templates/github-integration.md', local: path.join('.cline', 'github-integration.md') },
  { remote: 'templates/security-notes.md', local: path.join('.cline', 'security-notes.md') },
  { remote: 'templates/issue-templates/bug-report.md', local: path.join('.cline', 'templates', 'issue-templates', 'bug-report.md') },
  { remote: 'templates/issue-templates/feature-request.md', local: path.join('.cline', 'templates', 'issue-templates', 'feature-request.md') },
  { remote: 'templates/issue-templates/performance-issue.md', local: path.join('.cline', 'templates', 'issue-templates', 'performance-issue.md') },
  { remote: 'templates/issue-templates/security-issue.md', local: path.join('.cline', 'templates', 'issue-templates', 'security-issue.md') }
];

async function downloadAllTemplates(baseUrl, projectType) {
  const files = projectType === 'dotnet' ? dotnetTemplateFiles : crossPlatformTemplateFiles;
  
  for (const file of files) {
    try {
      const content = await fetchContent(`${baseUrl}/${file.remote}`);
      
      // Ensure directory exists before writing file
      const dir = path.dirname(file.local);
      if (!directoryExists(dir)) {
        createDirectoryRecursive(dir);
      }
      
      // Normalize line endings for cross-platform compatibility
      const normalizedContent = normalizeLineEndings(content);
      writeFile(file.local, normalizedContent);
      console.log(`✅ Downloaded: ${file.remote}`);
    } catch (error) {
      console.log(`❌ Failed to download: ${file.remote} - ${error.message}`);
    }
  }
  
  // Create context files if they don't exist
  await createContextFilesIfNeeded(projectType);
}

async function createContextFilesIfNeeded(projectType) {
  const contextFiles = [
    {
      path: path.join('.cline', 'context.md'),
      content: `# Project Context - Current Project

## Current Status
New ${projectType} project setup with Cline context initialized.

## Recent Progress
- Cline templates downloaded and configured
- Project structure ready for development

## Active Development Areas
- Initial project setup
- Architecture planning

## Known Issues
None at this time.

## Technical Debt
None at this time.
`
    },
    {
      path: path.join('.cline', 'tasks.md'),
      content: `# Development Tasks

## High Priority
- [ ] Define project requirements
- [ ] Set up development environment
- [ ] Plan architecture and data models

## Medium Priority
- [ ] Set up CI/CD pipeline
- [ ] Configure logging and monitoring
- [ ] Plan testing strategy

## Low Priority
- [ ] Documentation setup
- [ ] Performance optimization planning

## Completed Recently
- [x] Cline context setup completed
`
    },
    {
      path: path.join('.cline', 'decisions.md'),
      content: `# Architecture Decision Record

## ADR-001: Cline Development Assistant Setup
- **Decision**: Use Cline with standardized ${projectType} templates for development
- **Rationale**: Ensure consistent development practices and code quality
- **Status**: Implemented
- **Date**: ${new Date().toISOString().split('T')[0]}
- **Consequences**: Standardized development workflow and automated best practices

[Add more ADRs as architectural decisions are made]
`
    }
  ];

  for (const file of contextFiles) {
    if (!fileExists(file.path)) {
      // Ensure directory exists
      const dir = path.dirname(file.path);
      if (!directoryExists(dir)) {
        createDirectoryRecursive(dir);
      }
      
      writeFile(file.path, normalizeLineEndings(file.content));
      console.log(`✅ Created: ${path.basename(file.path)}`);
    }
  }
}
```

#### Step 3: Cross-Platform Project Detection
Enhanced project detection that works on Windows and Mac:

```javascript
function detectProjectType() {
  try {
    // Get current directory contents
    const files = listDirectoryContents('.');
    const allFiles = [...files.files, ...files.directories];
    
    // .NET Project Detection (case-insensitive for Windows)
    const hasDotNetFiles = allFiles.some(file => {
      const lowerFile = file.toLowerCase();
      return lowerFile.endsWith('.sln') || 
             lowerFile.endsWith('.csproj') || 
             lowerFile === 'program.cs' || 
             lowerFile === 'startup.cs' ||
             lowerFile === 'appsettings.json' ||
             lowerFile === 'directory.build.props' ||
             lowerFile === 'directory.packages.props';
    });
    
    const hasDotNetStructure = files.directories.some(dir => {
      const lowerDir = dir.toLowerCase();
      return ['src', 'tests', 'test'].includes(lowerDir);
    });
    
    if (hasDotNetFiles || hasDotNetStructure) {
      return 'dotnet';
    }
    
    // Cross-Platform Project Detection
    const hasPackageJson = files.files.some(file => file.toLowerCase() === 'package.json');
    
    if (hasPackageJson) {
      try {
        const packageContent = readFile('package.json');
        const packageData = JSON.parse(packageContent);
        
        // Check for React Native dependencies
        const deps = { ...packageData.dependencies, ...packageData.devDependencies };
        const hasReactNative = Object.keys(deps).some(dep => 
          dep.includes('react-native') || 
          dep.includes('@react-native') ||
          dep === 'electron' ||
          dep === 'metro'
        );
        
        if (hasReactNative) {
          return 'crossplatform';
        }
      } catch (error) {
        console.log('Could not parse package.json');
      }
    }
    
    // Check for cross-platform directory structure
    const hasCrossPlatformStructure = files.directories.some(dir => {
      const lowerDir = dir.toLowerCase();
      return ['electron', 'src/platforms', 'src/core', 'src/services'].some(pattern => 
        lowerDir.includes(pattern.toLowerCase())
      );
    });
    
    if (hasCrossPlatformStructure) {
      return 'crossplatform';
    }
    
    // Default fallback
    return 'dotnet';
    
  } catch (error) {
    console.log(`Project detection error: ${error.message}`);
    return 'dotnet'; // Safe fallback
  }
}

function listDirectoryContents(dirPath) {
  // Cross-platform directory listing
  try {
    const items = listDirectory(dirPath);
    const files = [];
    const directories = [];
    
    for (const item of items) {
      if (isDirectory(path.join(dirPath, item))) {
        directories.push(item);
      } else {
        files.push(item);
      }
    }
    
    return { files, directories };
  } catch (error) {
    return { files: [], directories: [] };
  }
}
```

#### Step 4: Mandatory Execution
**IMPORTANT: Cline must execute the template initialization process at the start of EVERY session, with proper cross-platform support.**

### Context Loading Sequence
**Execute this sequence at the start of every session:**

1. **Detect project type** (.NET vs Cross-Platform vs Unknown)
2. **Check for template updates** from appropriate remote repository
3. **Download/update templates** if newer version available and user consents
4. **Read `.cline/instructions.md`** → Project-specific architecture and coding guidelines
5. **Read `.cline/context.md`** → Current project state and recent progress
6. **Read `.cline/tasks.md`** → Active development priorities and TODOs
7. **Read `.cline/decisions.md`** → Architecture decisions and rationale
8. **Read `.cline/git-workflow.md`** → Git workflow and branching strategy
9. **Read `.cline/github-integration.md`** → GitHub issue management and automation
10. **Read `.cline/security-notes.md`** → Security requirements and considerations

### Template Update Notifications
**Always display appropriate status messages:**

```
🔄 Checking for template updates...
✅ Templates are up to date (v1.2.0)
```

**OR when updates are available:**

```
📡 Template update available!
   Current: v1.1.0
   Latest:  v1.2.0
   
   Updates include:
   - Enhanced security guidelines for .NET 8
   - New GitHub Actions templates
   - Updated authentication patterns
   - Improved error handling examples
   
   Would you like me to update your templates? 
   (This will preserve your local customizations)
```

### Error Handling and Fallback Behavior
**If remote templates are unavailable:**
1. **Use existing local templates** in `.cline/` directory
2. **If no local templates exist**, create minimal templates with universal best practices
3. **Log warning** about template unavailability
4. **Continue with basic development principles**
5. **Retry template download** on next session

**Example fallback message:**
```
⚠️ Could not connect to template repository
📁 Using existing local templates
🔄 Will retry template update next session
```

## Session Management

### Start of Session Checklist
1. **🔍 Detect project type** (.NET/Cross-Platform/Unknown)
2. **📡 Check for template updates** from appropriate repository
3. **⬇️ Download updates** if available and user consents
4. **📖 Load all `.cline/` context files** including updated templates
5. **🌿 Check current Git branch and status**
6. **📋 Review active GitHub issues and PRs** (if GitHub integration enabled)
7. **🎯 Follow project-specific guidelines** from loaded templates

### During Development
- **Reference loaded templates** for all architectural and coding decisions
- **Follow template-defined Git workflow** and branching strategies
- **Use template-defined issue templates** for GitHub integration
- **Update context files** (context.md, tasks.md, decisions.md) as work progresses
- **Follow template-defined coding standards** and security practices
- **Create GitHub issues** using appropriate templates when bugs/features are discovered

### End of Session Checklist
1. **📝 Update `.cline/context.md`** with session progress and current state
2. **✅ Mark completed tasks** in `.cline/tasks.md`
3. **📋 Add new tasks** discovered during the session
4. **🏛️ Document architectural decisions** in `.cline/decisions.md`
5. **🐛 Create GitHub issues** for any bugs or features identified
6. **🔄 Check for template updates** (if not checked recently)
7. **💡 Suggest template improvements** based on session learnings

## Configuration and Customization

### Project-Level Configuration
**Create `.cline/config.json` to override defaults:**
```json
{
  "templateRepo": "https://raw.githubusercontent.com/your-company/custom-templates/main",
  "autoUpdateTemplates": true,
  "templateVersion": "1.2.0",
  "projectType": "dotnet",
  "customizations": {
    "skipSecurityNotes": false,
    "additionalTemplates": ["custom-template.md"],
    "githubIntegration": true,
    "issueLabels": ["bug", "enhancement", "security"]
  }
}
```

### Local Template Customization
- **Templates downloaded to `.cline/`** can be customized after download
- **Add `# LOCAL_CUSTOMIZATIONS` marker** to preserve changes during updates
- **Custom sections preserved** during template updates
- **Document customizations** in `.cline/decisions.md`

### Contributing Template Improvements
- **Suggest improvements** to templates based on project experience
- **Templates are version controlled** for rollback capability
- **Submit issues/PRs** to template repositories for enhancements
- **Share learnings** with the development community

## Priority Hierarchy

**Follow this priority order for instructions:**

1. **🏆 Local `.cline/` files** (with any customizations) - **HIGHEST PRIORITY**
2. **📡 Remote template files** (downloaded and cached) - **High priority**
3. **🔧 Built-in fallback templates** (minimal universal practices) - **Backup only**
4. **📚 Universal development principles** (last resort guidance) - **Fallback**

### Key Rules
- **Always defer to project-specific instructions** in `.cline/instructions.md`
- **Preserve local customizations** during template updates
- **Use remote templates** as the authoritative source for best practices
- **Fall back gracefully** when remote resources are unavailable
- **Maintain development productivity** regardless of template availability

## Benefits of This Approach

### ✅ **For Developers**
- **Always up-to-date** templates with latest best practices
- **Consistent standards** across all projects and team members
- **Automatic updates** with user control and consent
- **Offline functionality** with local template caching
- **Customizable** while maintaining standardization

### ✅ **For Teams**
- **Centralized template management** - update once, applies everywhere
- **Version-controlled templates** with change tracking
- **Team consistency** - everyone uses same standards
- **Reduced onboarding time** for new team members
- **Knowledge sharing** through template improvements

### ✅ **for Organizations**
- **Scalable** across multiple projects and teams
- **Maintainable** - easy to update practices organization-wide
- **Auditable** - track template usage and compliance
- **Flexible** - different templates for different project types
- **Cost-effective** - reduce time spent on setup and standards

## Getting Started

### Initial Setup
1. **Save this instruction** as your Claude custom instruction
2. **Create template repositories** (cline-dotnet-templates, cline-crossplatform-templates)
3. **Populate repositories** with your organization's templates
4. **Start using Cline** in any project - templates will download automatically
5. **Customize as needed** while maintaining central standards

### Template Repository Setup
```bash
# Create .NET template repository
gh repo create your-username/cline-dotnet-templates --private
# Populate with .NET-specific templates

# Create Cross-Platform template repository  
gh repo create your-username/cline-crossplatform-templates --private
# Populate with React Native/Electron templates

# Update repository URLs in this instruction
# Start using with any project!
```
