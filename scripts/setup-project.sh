#!/bin/bash
# Bash Setup Commands for Mac/Linux

# 1. Create and setup the cross-platform repository
gh repo create GreenGavin/cline-crossplatform-templates --private
git clone https://github.com/GreenGavin/cline-crossplatform-templates.git
cd cline-crossplatform-templates

# 2. Create the folder structure (Bash compatible)
mkdir -p templates/issue-templates
mkdir -p configs
mkdir -p scripts

# 3. Create VERSION file
echo "1.0.0" > VERSION

# 4. Create template files (you'll copy content from artifacts)
touch templates/instructions.md
touch templates/git-workflow.md
touch templates/github-integration.md
touch templates/security-notes.md
touch templates/issue-templates/bug-report.md
touch templates/issue-templates/feature-request.md
touch templates/issue-templates/performance-issue.md
touch templates/issue-templates/security-issue.md

# 5. Create bash setup script
cat > scripts/setup-project.sh << 'EOF'
#!/bin/bash
# Cross-Platform Project Cline Setup Script

PROJECT_PATH=${1:-$(pwd)}
TEMPLATE_REPO=${2:-"https://raw.githubusercontent.com/GreenGavin/cline-crossplatform-templates/main"}

echo "🚀 Setting up Cline context for cross-platform project..."

# Ensure we're in the right directory
if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Project path does not exist: $PROJECT_PATH"
    exit 1
fi

cd "$PROJECT_PATH"

# Create .cline directory if it doesn't exist
if [ ! -d ".cline" ]; then
    mkdir -p ".cline"
    echo "✅ Created .cline directory"
fi

# Create templates subdirectory
if [ ! -d ".cline/templates" ]; then
    mkdir -p ".cline/templates/issue-templates"
    echo "✅ Created templates directory structure"
fi

# Function to download template files
download_template() {
    local file_name="$1"
    local local_path="$2"
    local url="${TEMPLATE_REPO}/templates/${file_name}"
    
    if curl -f -s "$url" -o "$local_path"; then
        echo "✅ Downloaded: $file_name"
    else
        echo "❌ Failed to download $file_name"
    fi
}

# Download main template files
echo "📡 Downloading template files..."

download_template "instructions.md" ".cline/instructions.md"
download_template "git-workflow.md" ".cline/git-workflow.md"
download_template "github-integration.md" ".cline/github-integration.md"
download_template "security-notes.md" ".cline/security-notes.md"

# Download issue templates
download_template "issue-templates/bug-report.md" ".cline/templates/issue-templates/bug-report.md"
download_template "issue-templates/feature-request.md" ".cline/templates/issue-templates/feature-request.md"
download_template "issue-templates/performance-issue.md" ".cline/templates/issue-templates/performance-issue.md"
download_template "issue-templates/security-issue.md" ".cline/templates/issue-templates/security-issue.md"

echo "🎉 Setup complete!"
EOF

chmod +x scripts/setup-project.sh

# 6. Create RELEASE_NOTES.md
cat > RELEASE_NOTES.md << EOF
# Template Release Notes

## Version 1.0.0 - $(date '+%B %Y')

### 🎉 Initial Release
Welcome to the **Cline Cross-Platform Development Templates**! Advanced templates for privacy-focused, offline-first applications.

### 🆕 What's Included
- **Cross-Platform Instructions** - React Native, Electron, and web development
- **Git Workflow** - Multi-platform branching and release strategies
- **GitHub Integration** - Issue templates and automation
- **Security Guidelines** - End-to-end encryption and privacy-first development

### 🚀 Key Features
- **Offline-First Architecture** - Full functionality without internet
- **Privacy-by-Design** - Zero-knowledge architecture
- **Multi-Platform** - Web, iOS, Android, Windows, macOS
- **End-to-End Encryption** - Client-side encryption for all data

### 📋 Getting Started
1. Update your Cline custom instruction with the dynamic template system
2. Open any React Native/Electron project - templates download automatically
3. Follow offline-first and privacy-focused development guidelines
4. Use GitHub integration for comprehensive issue management

### 🎯 What's Next
- Enhanced encryption patterns
- Performance optimization templates
- Advanced offline sync strategies
- Multi-cloud architecture patterns

**Build privacy-focused apps that respect users!** 🚀
EOF

# 7. Create README.md
cat > README.md << 'EOF'
# Cline Cross-Platform Development Templates

Advanced templates for offline-first, privacy-focused cross-platform applications using React Native, Electron, and modern web technologies.

## 🌐 Supported Platforms
- **Web**: React Native Web with Progressive Web App features
- **iOS**: React Native iOS with native integrations
- **Android**: React Native Android with Material Design
- **Windows**: Electron + React Native Windows
- **macOS**: Electron + React Native macOS

## 🏗️ Architecture Philosophy
- **Offline-First** - Works without internet connection
- **Privacy-by-Design** - Zero-knowledge architecture
- **Family-Friendly** - Multi-user with granular permissions
- **End-to-End Encryption** - All data encrypted client-side

## 🚀 Quick Setup
Templates download automatically when you use Cline in any cross-platform project.

### Manual Setup (if needed)
```bash
./scripts/setup-project.sh /path/to/your/project
```

## 📋 Templates Included
- **Cross-Platform Instructions** - Comprehensive development guidelines
- **Git Workflow** - Multi-platform branching strategies
- **GitHub Integration** - Advanced issue management
- **Security Guidelines** - End-to-end encryption implementation
- **Performance Templates** - Cross-platform optimization

## 🔧 Technology Stack
- React Native 0.73+ with New Architecture
- React Native Web for web deployment
- Electron for desktop applications
- TypeScript with strict configuration
- PouchDB for offline-first data storage

## 🔐 Security Features
- AES-256-GCM encryption
- Zero-knowledge architecture
- Multi-provider cloud sync (Dropbox, OneDrive, iCloud, Google Drive)
- Biometric authentication integration
- GDPR/CCPA compliance built-in

## 🔄 Version
Current Version: 1.0.0

Designed for teams building privacy-focused, offline-first applications.
EOF

# 8. Create architecture configs
cat > configs/offline-first.md << 'EOF'
# Offline-First Architecture Configuration

## Core Principles
- All functionality must work without internet connection
- Data sync is enhancement, not requirement
- Local-first data storage with PouchDB
- Client-side encryption before cloud sync
- Conflict resolution with user involvement

## Implementation Guidelines
- Use PouchDB for local database with CouchDB sync
- Implement queue system for offline operations
- Cache all user interface assets locally
- Provide clear offline/online indicators
- Handle sync conflicts gracefully with user choice
EOF

# 9. Add and commit everything
git add .
git commit -m "feat: initial cross-platform templates with offline-first architecture

- Comprehensive cross-platform development instructions
- Multi-platform Git workflow and release management
- Advanced GitHub integration with performance issue templates
- End-to-end encryption and privacy-first security guidelines
- Offline-first architecture with PouchDB and cloud sync
- Cross-platform setup script for project initialization"

git push origin main

echo ""
echo "🎉 Cross-platform repository setup complete!"
echo "📋 Next steps:"
echo "1. Copy content from artifacts into template files"
echo "2. Test the setup script on a sample project"
echo "3. Update your Cline custom instruction"