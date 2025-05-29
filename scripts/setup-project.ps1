# PowerShell Setup Commands for Windows

# 1. Create and setup the .NET repository
gh repo create GreenGavin/cline-dotnet-templates --private
git clone https://github.com/GreenGavin/cline-dotnet-templates.git
Set-Location cline-dotnet-templates

# 2. Create the folder structure (PowerShell compatible)
New-Item -ItemType Directory -Path "templates" -Force
New-Item -ItemType Directory -Path "templates\issue-templates" -Force
New-Item -ItemType Directory -Path "configs" -Force
New-Item -ItemType Directory -Path "scripts" -Force

# 3. Create VERSION file
Set-Content -Path "VERSION" -Value "1.0.0"

# 4. Create template files (you'll copy content from artifacts)
New-Item -ItemType File -Path "templates\instructions.md" -Force
New-Item -ItemType File -Path "templates\git-workflow.md" -Force
New-Item -ItemType File -Path "templates\github-integration.md" -Force
New-Item -ItemType File -Path "templates\security-notes.md" -Force
New-Item -ItemType File -Path "templates\issue-templates\bug-report.md" -Force
New-Item -ItemType File -Path "templates\issue-templates\feature-request.md" -Force
New-Item -ItemType File -Path "templates\issue-templates\security-issue.md" -Force

# 5. Create PowerShell setup script
Set-Content -Path "scripts\setup-project.ps1" -Value @"
# .NET Project Cline Setup Script
param(
    [Parameter(Mandatory=`$true)]
    [string]`$ProjectPath,
    
    [Parameter(Mandatory=`$false)]
    [string]`$TemplateRepo = "https://raw.githubusercontent.com/GreenGavin/cline-dotnet-templates/main"
)

Write-Host "🚀 Setting up Cline context for .NET project..." -ForegroundColor Green

# Ensure we're in the right directory
if (!(Test-Path `$ProjectPath)) {
    Write-Error "Project path does not exist: `$ProjectPath"
    exit 1
}

Set-Location `$ProjectPath

# Create .cline directory if it doesn't exist
if (!(Test-Path ".cline")) {
    New-Item -ItemType Directory -Path ".cline" -Force
    Write-Host "✅ Created .cline directory" -ForegroundColor Green
}

# Create templates subdirectory
if (!(Test-Path ".cline\templates")) {
    New-Item -ItemType Directory -Path ".cline\templates" -Force
    New-Item -ItemType Directory -Path ".cline\templates\issue-templates" -Force
    Write-Host "✅ Created templates directory structure" -ForegroundColor Green
}

# Function to download template files
function Download-Template {
    param(`$FileName, `$LocalPath)
    
    try {
        `$url = "`$TemplateRepo/templates/`$FileName"
        Invoke-WebRequest -Uri `$url -OutFile `$LocalPath -UseBasicParsing
        Write-Host "✅ Downloaded: `$FileName" -ForegroundColor Green
    }
    catch {
        Write-Warning "❌ Failed to download `$FileName`: `$_"
    }
}

# Download main template files
Write-Host "📡 Downloading template files..." -ForegroundColor Cyan

Download-Template "instructions.md" ".cline\instructions.md"
Download-Template "git-workflow.md" ".cline\git-workflow.md"
Download-Template "github-integration.md" ".cline\github-integration.md"
Download-Template "security-notes.md" ".cline\security-notes.md"

# Download issue templates
Download-Template "issue-templates/bug-report.md" ".cline\templates\issue-templates\bug-report.md"
Download-Template "issue-templates/feature-request.md" ".cline\templates\issue-templates\feature-request.md"
Download-Template "issue-templates/security-issue.md" ".cline\templates\issue-templates\security-issue.md"

Write-Host "🎉 Setup complete!" -ForegroundColor Green
"@

# 6. Create RELEASE_NOTES.md
Set-Content -Path "RELEASE_NOTES.md" -Value @"
# Template Release Notes

## Version 1.0.0 - $(Get-Date -Format 'MMMM yyyy')

### 🎉 Initial Release
Welcome to the **Cline .NET Development Templates** system! Professional templates for enterprise-grade .NET development.

### 🆕 What's Included
- **Development Instructions** - Comprehensive .NET coding guidelines
- **Git Workflow** - Professional Git branching and commit conventions  
- **GitHub Integration** - Issue templates and CLI automation
- **Security Guidelines** - Security-first .NET development practices

### 🚀 Key Features
- **Automatic Template Management** - Smart project detection and updates
- **Enterprise Standards** - Clean Architecture and SOLID principles
- **Security-First** - OWASP compliance and secure coding practices
- **Cross-Platform** - Works on Windows, Mac, and Linux

### 📋 Getting Started
1. Update your Cline custom instruction with the dynamic template system
2. Open any .NET project - templates download automatically
3. Follow professional development guidelines
4. Use GitHub integration for issue management

### 🎯 What's Next
- Enhanced security templates
- CI/CD pipeline templates  
- Microservices architecture patterns
- Cloud deployment guidelines

**Happy coding!** 🚀
"@

# 7. Create README.md
Set-Content -Path "README.md" -Value @"
# Cline .NET Development Templates

Professional templates for .NET projects using Cline AI assistant with enterprise-grade standards.

## 🎯 Target Projects
- ASP.NET Core Web APIs and MVC applications
- Clean Architecture enterprise applications
- Microservices with .NET 8+
- Blazor web applications

## 🚀 Quick Setup
Templates download automatically when you use Cline in any .NET project.

### Manual Setup (if needed)
``````powershell
.\scripts\setup-project.ps1 -ProjectPath "C:\path\to\your\project"
``````

## 📋 Templates Included
- **Development Instructions** - Comprehensive .NET guidelines
- **Git Workflow** - Professional Git practices
- **GitHub Integration** - Issue management and automation
- **Security Guidelines** - Security-first development

## 🔧 Features
- **Automatic Updates** - Templates stay current
- **Enterprise Standards** - Clean Architecture and SOLID principles
- **Security-First** - OWASP compliance built-in
- **Cross-Platform** - Windows, Mac, Linux support

## 🔄 Version
Current Version: 1.0.0

Built for professional .NET development teams.
"@

# 8. Add and commit everything
git add .
git commit -m "feat: initial .NET templates with comprehensive development guidelines

- Professional .NET development instructions
- Git workflow with conventional commits
- GitHub integration and issue templates
- Security-first development practices
- Cross-platform PowerShell setup script
- Enterprise-grade standards and patterns"

git push origin main

Write-Host ""
Write-Host "🎉 .NET repository setup complete!" -ForegroundColor Green
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Copy content from artifacts into template files" -ForegroundColor Gray
Write-Host "2. Test the setup script on a sample project" -ForegroundColor Gray
Write-Host "3. Update your Cline custom instruction" -ForegroundColor Gray