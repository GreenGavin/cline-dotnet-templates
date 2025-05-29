# .NET Project Cline Setup Script
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    
    [Parameter(Mandatory=$false)]
    [string]$TemplateRepo = "https://raw.githubusercontent.com/GreenGavin/cline-dotnet-templates/main"
)

Write-Host "🚀 Setting up Cline context for .NET project..." -ForegroundColor Green

# Ensure we're in the right directory
if (!(Test-Path $ProjectPath)) {
    Write-Error "Project path does not exist: $ProjectPath"
    exit 1
}

Set-Location $ProjectPath

# Create .cline directory if it doesn't exist
if (!(Test-Path ".cline")) {
    New-Item -ItemType Directory -Path ".cline"
    Write-Host "✅ Created .cline directory" -ForegroundColor Green
}

# Create templates subdirectory
if (!(Test-Path ".cline\templates")) {
    New-Item -ItemType Directory -Path ".cline\templates"
    New-Item -ItemType Directory -Path ".cline\templates\issue-templates"
    Write-Host "✅ Created templates directory structure" -ForegroundColor Green
}

# Function to download template files
function Download-Template {
    param($FileName, $LocalPath)
    
    try {
        $url = "$TemplateRepo/templates/$FileName"
        Invoke-WebRequest -Uri $url -OutFile $LocalPath -UseBasicParsing
        Write-Host "✅ Downloaded: $FileName" -ForegroundColor Green
    }
    catch {
        Write-Warning "❌ Failed to download $FileName`: $_"
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

# Create basic context files if they don't exist
if (!(Test-Path ".cline\context.md")) {
    $contextContent = @"
# Project Context - $((Get-Item $ProjectPath).Name)

## Current Status
New .NET project setup with Cline context initialized.

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
"@
    Set-Content -Path ".cline\context.md" -Value $contextContent
    Write-Host "✅ Created context.md" -ForegroundColor Green
}

if (!(Test-Path ".cline\tasks.md")) {
    $tasksContent = @"
# Development Tasks

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
"@
    Set-Content -Path ".cline\tasks.md" -Value $tasksContent
    Write-Host "✅ Created tasks.md" -ForegroundColor Green
}

if (!(Test-Path ".cline\decisions.md")) {
    $decisionsContent = @"
# Architecture Decision Record

## ADR-001: Cline Development Assistant Setup
- **Decision**: Use Cline with standardized .NET templates for development
- **Rationale**: Ensure consistent development practices and code quality
- **Status**: Implemented
- **Date**: $(Get-Date -Format 'yyyy-MM-dd')
- **Consequences**: Standardized development workflow and automated best practices

[Add more ADRs as architectural decisions are made]
"@
    Set-Content -Path ".cline\decisions.md" -Value $decisionsContent
    Write-Host "✅ Created decisions.md" -ForegroundColor Green
}

# Download and save the current template version
try {
    $version = Invoke-WebRequest -Uri "$TemplateRepo/VERSION" -UseBasicParsing
    Set-Content -Path ".cline\TEMPLATE_VERSION" -Value $version.Content.Trim()
    Write-Host "✅ Template version: $($version.Content.Trim())" -ForegroundColor Green
}
catch {
    Write-Warning "❌ Could not retrieve template version"
    Set-Content -Path ".cline\TEMPLATE_VERSION" -Value "1.0.0"
}

# Check if this is a .NET project and provide specific guidance
$hasSolution = Get-ChildItem -Path $ProjectPath -Filter "*.sln" -ErrorAction SilentlyContinue
$hasProjects = Get-ChildItem -Path $ProjectPath -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue

if ($hasSolution -or $hasProjects) {
    Write-Host "🎯 .NET project detected!" -ForegroundColor Cyan
    
    if ($hasSolution) {
        Write-Host "   Solution file: $($hasSolution.Name)" -ForegroundColor Gray
    }
    
    if ($hasProjects) {
        Write-Host "   Project files found: $($hasProjects.Count)" -ForegroundColor Gray
    }
} else {
    Write-Host "⚠️  No .NET solution or project files detected." -ForegroundColor Yellow
    Write-Host "   Make sure you're in the correct directory or create your .NET project first." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Cline setup complete!" -ForegroundColor Green
Write-Host "📁 Files created in .cline/ directory:" -ForegroundColor Cyan
Get-ChildItem -Path ".cline" -Recurse | ForEach-Object {
    Write-Host "   $($_.FullName.Replace((Get-Location).Path, '.'))" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Review and customize .cline/instructions.md for your project" -ForegroundColor Gray
Write-Host "2. Update .cline/context.md with your project specifics" -ForegroundColor Gray
Write-Host "3. Add your initial tasks to .cline/tasks.md" -ForegroundColor Gray
Write-Host "4. Start using Cline with your standardized development workflow!" -ForegroundColor Gray