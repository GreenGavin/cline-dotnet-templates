# [Solution Name] - .NET Development Instructions

## Project Overview
Brief: [One-sentence project description]
For detailed context, see `.cline/context.md`

## Architecture Principles
- Follow Clean Architecture or Domain-Driven Design patterns
- Implement SOLID principles throughout the codebase
- Use dependency injection for loose coupling
- Separate concerns into appropriate layers
- Implement proper error handling and logging

## Tech Stack
- **Framework**: .NET 8+ (specify exact version for project)
- **Language**: C# 12+ with nullable reference types enabled
- **Database**: [SQL Server, PostgreSQL, SQLite, etc.]
- **Testing**: xUnit with FluentAssertions and Moq
- **Logging**: Microsoft.Extensions.Logging with Serilog
- **API**: ASP.NET Core Web API with OpenAPI/Swagger
- **Authentication**: ASP.NET Core Identity or JWT Bearer tokens
- **ORM**: Entity Framework Core

## Code Standards

### C# Coding Conventions
- Follow Microsoft C# coding conventions
- Use PascalCase for public members, camelCase for private fields
- Use meaningful names that express intent
- Keep methods small and focused (max 20-30 lines)
- Use nullable reference types throughout
- Implement proper async/await patterns for I/O operations

### Code Commenting
Ensure the code is commented as you are writing or refactoring it. If no comments are found add them. Ensure the structure of the classes matches the below regions breakdown.

Adjust the regions to the generally recommended order of: 
{ Constants, Fields, Enums, Events, Properties, Constructors, Methods, Nested Types }

### Project Structure
```
Solution.sln
├── src/
│   ├── Solution.Domain/          # Domain entities, value objects, interfaces
│   ├── Solution.Application/     # Use cases, application services, DTOs
│   ├── Solution.Infrastructure/  # Data access, external services
│   ├── Solution.Web.API/         # Controllers, middleware, configuration
│   └── Solution.Web.UI/          # UI project (if applicable)
├── tests/
│   ├── Solution.UnitTests/       # Unit tests for business logic
│   ├── Solution.IntegrationTests/ # Integration tests
│   └── Solution.ArchitectureTests/ # Architecture constraint tests
└── docs/                         # Documentation
```

### Dependency Management
- Use dependency injection container (Microsoft.Extensions.DependencyInjection)
- Register services with appropriate lifetimes (Singleton, Scoped, Transient)
- Use the Options pattern for configuration
- Implement factory patterns for complex object creation

## Security Requirements

### Authentication & Authorization
- Implement proper authentication (JWT, Cookie, or OAuth 2.0)
- Use role-based or claims-based authorization
- Validate all inputs using Data Annotations or FluentValidation
- Implement rate limiting and request throttling
- Use HTTPS everywhere in production

### Data Protection
- Encrypt sensitive data at rest and in transit
- Use parameterized queries to prevent SQL injection
- Implement proper CORS policies
- Follow OWASP security guidelines for .NET
- Use secure headers (HSTS, CSP, X-Frame-Options)
- Implement proper session management

### Security Testing
- Include security-focused unit tests
- Use static analysis tools (SonarQube, CodeQL)
- Implement automated security scanning in CI/CD
- Regular dependency vulnerability scanning

## Development Workflow

### Testing Strategy
- Write unit tests for all business logic (aim for >80% coverage)
- Implement integration tests for API endpoints
- Use TestContainers for database integration tests
- Implement end-to-end tests for critical user journeys
- Use mutation testing to verify test quality

### Code Quality
- Use EditorConfig for consistent formatting
- Implement pre-commit hooks for code quality checks
- Use analyzers (Microsoft.CodeAnalysis.Analyzers)
- Regular code reviews with security focus
- Document complex business logic and architectural decisions

### CI/CD Pipeline
- Automated build on every commit
- Run all tests before allowing merge
- Automated deployment to staging environment
- Code coverage reporting
- Security vulnerability scanning

## Performance Considerations

### Database Optimization
- Use appropriate indexing strategies
- Implement query optimization and avoid N+1 problems
- Use connection pooling effectively
- Consider read replicas for read-heavy workloads
- Implement caching strategies (in-memory, distributed)

### API Performance
- Implement proper pagination for large datasets
- Use compression for API responses
- Implement API versioning strategy
- Use async/await for I/O-bound operations
- Consider implementing CQRS for complex read/write scenarios

## Monitoring & Observability

### Logging
- Use structured logging with Serilog
- Implement correlation IDs for request tracing
- Log appropriate levels (Debug, Info, Warning, Error, Critical)
- Never log sensitive information
- Implement centralized logging (e.g., ELK stack, Azure Monitor)

### Metrics & Monitoring
- Implement health checks for dependencies
- Use Application Performance Monitoring (APM)
- Monitor key business metrics
- Set up alerting for critical issues
- Implement distributed tracing for microservices

## Git Workflow
Follow the git workflow outlined in `git-workflow.md` for:
- Branch naming conventions
- Commit message standards
- Pull request processes
- Code review requirements

## GitHub Integration
Reference `github-integration.md` for:
- Repository setup and configuration
- CI/CD pipeline configuration
- Issue and pull request templates
- GitHub Actions workflows

## Security Notes
Follow all security guidelines in `security-notes.md` including:
- Authentication and authorization patterns
- Data protection requirements
- Security testing procedures
- Vulnerability management

## Documentation Standards
- Maintain up-to-date README files
- Document API endpoints with OpenAPI/Swagger
- Create architectural decision records (ADRs)
- Document deployment procedures
- Maintain troubleshooting guides

Remember: Security, performance, and maintainability should be considered from the beginning, not added as an afterthought.