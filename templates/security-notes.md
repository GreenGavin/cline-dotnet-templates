# Security Implementation Guidelines for .NET Projects

## Authentication & Authorization

### Current Implementation Standards
- **Authentication Method**: [JWT Bearer tokens, Cookie authentication, Azure AD, etc.]
- **Authorization Strategy**: [Role-based, Claims-based, Policy-based]
- **Multi-Factor Authentication**: [Enabled/Planned/Not applicable]
- **Session Management**: [Token expiration, refresh tokens, session timeout]

### Implementation Checklist
- [ ] Strong password policies implemented
- [ ] Account lockout mechanisms in place
- [ ] Secure password storage (bcrypt, Argon2, or PBKDF2)
- [ ] JWT tokens signed with strong algorithms (RS256, ES256)
- [ ] Refresh token rotation implemented
- [ ] Proper logout functionality (token invalidation)
- [ ] Protection against session fixation
- [ ] CSRF tokens for state-changing operations

### Code Examples
```csharp
// Secure JWT configuration
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = configuration["Jwt:Issuer"],
            ValidAudience = configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["Jwt:SecretKey"])),
            ClockSkew = TimeSpan.Zero // Remove default 5-minute clock skew
        };
    });

// Secure authorization policies
services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy => policy.RequireRole("Admin"));
    options.AddPolicy("RequireManagerClaim", policy => 
        policy.RequireClaim("Department", "Management"));
});
```

## Data Protection

### Encryption Standards
- **Data at Rest**: [AES-256, database-level encryption, file system encryption]
- **Data in Transit**: [TLS 1.3, certificate pinning, HTTPS everywhere]
- **Key Management**: [Azure Key Vault, AWS KMS, Hardware Security Module]
- **Sensitive Data Fields**: [PII encryption, payment data, health records]

### Implementation Guidelines
```csharp
// Data protection configuration
services.AddDataProtection()
    .PersistKeysToAzureBlobStorage(connectionString, containerName, blobName)
    .ProtectKeysWithAzureKeyVault(keyVaultUri, credential)
    .SetDefaultKeyLifetime(TimeSpan.FromDays(90));

// Encrypt sensitive model properties
public class User
{
    public int Id { get; set; }
    public string Username { get; set; }
    
    [PersonalData] // Automatically encrypted by Identity
    public string Email { get; set; }
    
    [PersonalData]
    public string PhoneNumber { get; set; }
}

// Custom field encryption
public class EncryptedStringConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return _dataProtector.Protect(value?.ToString() ?? string.Empty);
    }
    
    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
        return _dataProtector.Unprotect(value?.ToString() ?? string.Empty);
    }
}
```

### Sensitive Data Handling
- [ ] PII identified and classified
- [ ] Encryption applied to sensitive fields
- [ ] Secure key storage and rotation
- [ ] Data masking in logs and error messages
- [ ] Secure data disposal procedures
- [ ] Compliance with GDPR, CCPA, HIPAA (as applicable)

## Input Validation & Sanitization

### Validation Strategy
- **Server-Side Validation**: Always validate on the server
- **Client-Side Validation**: For user experience only, never rely solely
- **Whitelist Approach**: Allow known good inputs rather than blocking bad
- **Data Type Validation**: Ensure data matches expected types and formats

### Implementation Patterns
```csharp
// Model validation with Data Annotations
public class CreateUserRequest
{
    [Required(ErrorMessage = "Username is required")]
    [StringLength(50, MinimumLength = 3)]
    [RegularExpression(@"^[a-zA-Z0-9_]+$", ErrorMessage = "Username can only contain letters, numbers, and underscores")]
    public string Username { get; set; }

    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 8)]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]", 
        ErrorMessage = "Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character")]
    public string Password { get; set; }
}

// FluentValidation for complex scenarios
public class CreateUserValidator : AbstractValidator<CreateUserRequest>
{
    public CreateUserValidator()
    {
        RuleFor(x => x.Username)
            .NotEmpty()
            .Length(3, 50)
            .Matches(@"^[a-zA-Z0-9_]+$")
            .MustAsync(async (username, cancellation) => 
                await _userService.IsUsernameAvailableAsync(username))
            .WithMessage("Username is already taken");

        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .MustAsync(async (email, cancellation) => 
                await _userService.IsEmailAvailableAsync(email))
            .WithMessage("Email is already registered");
    }
}

// HTML sanitization for rich text inputs
public class HtmlSanitizer
{
    private readonly IHtmlSanitizer _sanitizer;

    public HtmlSanitizer()
    {
        _sanitizer = new Ganss.Xss.HtmlSanitizer();
        _sanitizer.AllowedTags.Clear();
        _sanitizer.AllowedTags.Add("p");
        _sanitizer.AllowedTags.Add("br");
        _sanitizer.AllowedTags.Add("strong");
        _sanitizer.AllowedTags.Add("em");
    }

    public string Sanitize(string html)
    {
        return _sanitizer.Sanitize(html);
    }
}
```

## SQL Injection Prevention

### Parameterized Queries
```csharp
// Entity Framework Core (safe by default)
public async Task<User> GetUserByIdAsync(int userId)
{
    return await _context.Users
        .Where(u => u.Id == userId) // Parameterized automatically
        .FirstOrDefaultAsync();
}

// Raw SQL with parameters
public async Task<List<User>> SearchUsersAsync(string searchTerm)
{
    return await _context.Users
        .FromSqlRaw("SELECT * FROM Users WHERE Username LIKE {0} OR Email LIKE {0}", 
            $"%{searchTerm}%")
        .ToListAsync();
}

// Dapper with parameters
public async Task<User> GetUserAsync(int userId)
{
    const string sql = "SELECT * FROM Users WHERE Id = @UserId";
    return await _connection.QuerySingleOrDefaultAsync<User>(sql, new { UserId = userId });
}
```

### Dynamic Query Safety
```csharp
// Safe dynamic query building
public IQueryable<User> BuildUserQuery(UserSearchCriteria criteria)
{
    var query = _context.Users.AsQueryable();

    if (!string.IsNullOrEmpty(criteria.Username))
    {
        query = query.Where(u => u.Username.Contains(criteria.Username));
    }

    if (criteria.IsActive.HasValue)
    {
        query = query.Where(u => u.IsActive == criteria.IsActive.Value);
    }

    return query;
}
```

## Cross-Site Scripting (XSS) Prevention

### Output Encoding
```csharp
// Razor automatically encodes by default
<p>Hello @Model.Username</p> <!-- Safe -->

// When you need raw HTML (be very careful)
<div>@Html.Raw(Model.SanitizedContent)</div> <!-- Only with sanitized content -->

// API responses (JSON encoding)
public class ApiResponse<T>
{
    [JsonPropertyName("data")]
    public T Data { get; set; }
    
    [JsonPropertyName("message")]
    public string Message { get; set; } // Automatically encoded in JSON
}
```

### Content Security Policy
```csharp
// CSP middleware
public void Configure(IApplicationBuilder app)
{
    app.Use(async (context, next) =>
    {
        context.Response.Headers.Add("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' cdn.jsdelivr.net; " +
            "style-src 'self' 'unsafe-inline' fonts.googleapis.com; " +
            "font-src 'self' fonts.gstatic.com; " +
            "img-src 'self' data: https:; " +
            "connect-src 'self'");
        await next();
    });
}
```

## HTTPS and Transport Security

### HTTPS Configuration
```csharp
// Force HTTPS in production
public void ConfigureServices(IServiceCollection services)
{
    services.AddHttpsRedirection(options =>
    {
        options.RedirectStatusCode = StatusCodes.Status307TemporaryRedirect;
        options.HttpsPort = 443;
    });

    services.AddHsts(options =>
    {
        options.Preload = true;
        options.IncludeSubDomains = true;
        options.MaxAge = TimeSpan.FromDays(365);
    });
}

public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    if (!env.IsDevelopment())
    {
        app.UseHsts();
    }
    
    app.UseHttpsRedirection();
}
```

### Secure Headers
```csharp
// Security headers middleware
public class SecurityHeadersMiddleware
{
    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        context.Response.Headers.Add("X-Content-Type-Options", "nosniff");
        context.Response.Headers.Add("X-Frame-Options", "DENY");
        context.Response.Headers.Add("X-XSS-Protection", "1; mode=block");
        context.Response.Headers.Add("Referrer-Policy", "strict-origin-when-cross-origin");
        context.Response.Headers.Add("Permissions-Policy", "geolocation=(), microphone=(), camera=()");
        
        await next(context);
    }
}
```

## Error Handling & Information Disclosure

### Secure Error Handling
```csharp
// Global exception handler
public class GlobalExceptionMiddleware
{
    private readonly ILogger<GlobalExceptionMiddleware> _logger;

    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        try
        {
            await next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unhandled exception occurred");
            await HandleExceptionAsync(context, ex);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        context.Response.ContentType = "application/json";
        
        var response = new ErrorResponse();
        
        switch (exception)
        {
            case ValidationException validationEx:
                response.Message = "Validation failed";
                response.Details = validationEx.Errors;
                context.Response.StatusCode = 400;
                break;
            case UnauthorizedAccessException:
                response.Message = "Access denied";
                context.Response.StatusCode = 401;
                break;
            case NotFoundException:
                response.Message = "Resource not found";
                context.Response.StatusCode = 404;
                break;
            default:
                response.Message = "An error occurred while processing your request";
                context.Response.StatusCode = 500;
                break;
        }

        // Never expose internal exception details in production
        if (!_environment.IsDevelopment())
        {
            response.StackTrace = null;
            response.InternalMessage = null;
        }

        var jsonResponse = JsonSerializer.Serialize(response);
        await context.Response.WriteAsync(jsonResponse);
    }
}

// Secure logging practices
public class UserService
{
    private readonly ILogger<UserService> _logger;

    public async Task<User> AuthenticateAsync(string username, string password)
    {
        try
        {
            var user = await _userRepository.GetByUsernameAsync(username);
            
            if (user == null || !_passwordHasher.VerifyPassword(password, user.PasswordHash))
            {
                // Log security events without exposing sensitive data
                _logger.LogWarning("Failed login attempt for username: {Username} from IP: {IpAddress}", 
                    username, _httpContextAccessor.HttpContext?.Connection?.RemoteIpAddress);
                return null;
            }

            _logger.LogInformation("Successful login for user ID: {UserId}", user.Id);
            return user;
        }
        catch (Exception ex)
        {
            // Log exception without sensitive data
            _logger.LogError(ex, "Authentication error occurred");
            throw;
        }
    }
}
```

## Dependency Security

### Package Management
```xml
<!-- Use central package management -->
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <WarningsAsErrors />
    <WarningsNotAsErrors>NU1901;NU1902;NU1903;NU1904</WarningsNotAsErrors>
  </PropertyGroup>
</Project>

<!-- Directory.Packages.props -->
<Project>
  <ItemGroup>
    <PackageVersion Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="8.0.0" />
    <PackageVersion Include="Microsoft.EntityFrameworkCore" Version="8.0.0" />
    <PackageVersion Include="Serilog.AspNetCore" Version="8.0.0" />
  </ItemGroup>
</Project>
```

### Vulnerability Scanning
```bash
# Regular dependency auditing
dotnet list package --vulnerable
dotnet list package --deprecated
dotnet list package --outdated

# NuGet security audit
nuget audit

# Use tools like OWASP Dependency Check
dependency-check --project "MyProject" --scan "./bin" --format HTML --out "./reports"
```

### Secure Package Selection
- [ ] Verify package authenticity and signatures
- [ ] Check package download statistics and community trust
- [ ] Review package dependencies for security issues
- [ ] Prefer Microsoft and well-established packages
- [ ] Regular security updates and maintenance
- [ ] Use package version pinning for production

## Configuration Security

### Secure Configuration Management
```csharp
// appsettings.json (never store secrets here)
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MyApp;Trusted_Connection=true;"
  },
  "Jwt": {
    "Issuer": "MyApp",
    "Audience": "MyAppUsers",
    "ExpirationMinutes": 60
  }
}

// User secrets for development (dotnet user-secrets set "Jwt:SecretKey" "your-secret-key")
// Azure Key Vault for production
public void ConfigureServices(IServiceCollection services)
{
    if (_environment.IsProduction())
    {
        var keyVaultEndpoint = _configuration["KeyVault:Endpoint"];
        var credential = new DefaultAzureCredential();
        _configuration.AddAzureKeyVault(new Uri(keyVaultEndpoint), credential);
    }
}

// Environment-specific settings
public class JwtSettings
{
    public const string SectionName = "Jwt";
    
    public string Issuer { get; set; } = string.Empty;
    public string Audience { get; set; } = string.Empty;
    public string SecretKey { get; set; } = string.Empty; // From Key Vault
    public int ExpirationMinutes { get; set; } = 60;
}
```

### Environment Variables Security
```bash
# Production environment variables
export ASPNETCORE_ENVIRONMENT=Production
export CONNECTIONSTRINGS__DEFAULTCONNECTION="encrypted-connection-string"
export JWT__SECRETKEY="your-secure-jwt-secret"

# Never commit .env files with secrets
# Use Azure App Configuration or AWS Parameter Store
```

## Rate Limiting & DoS Protection

### Implementation
```csharp
// Built-in rate limiting (.NET 7+)
public void ConfigureServices(IServiceCollection services)
{
    services.AddRateLimiter(options =>
    {
        options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(
            httpContext => RateLimitPartition.GetFixedWindowLimiter(
                partitionKey: httpContext.User.Identity?.Name ?? httpContext.Request.Headers.Host.ToString(),
                factory: partition => new FixedWindowRateLimiterOptions
                {
                    PermitLimit = 100,
                    Window = TimeSpan.FromMinutes(1),
                    QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                    QueueLimit = 10
                }));

        options.AddPolicy("LoginAttempts", httpContext =>
            RateLimitPartition.GetFixedWindowLimiter(
                partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
                factory: partition => new FixedWindowRateLimiterOptions
                {
                    PermitLimit = 5,
                    Window = TimeSpan.FromMinutes(15)
                }));
    });
}

// Apply rate limiting to endpoints
[HttpPost("login")]
[EnableRateLimiting("LoginAttempts")]
public async Task<IActionResult> Login(LoginRequest request)
{
    // Login logic
}
```

### Request Size Limits
```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.Configure<FormOptions>(options =>
    {
        options.ValueLengthLimit = 1024 * 1024; // 1MB
        options.MultipartBodyLengthLimit = 10 * 1024 * 1024; // 10MB
        options.MultipartHeadersLengthLimit = 1024;
    });

    services.Configure<IISServerOptions>(options =>
    {
        options.MaxRequestBodySize = 10 * 1024 * 1024; // 10MB
    });
}
```

## API Security

### API Versioning
```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddApiVersioning(options =>
    {
        options.DefaultApiVersion = new ApiVersion(1, 0);
        options.AssumeDefaultVersionWhenUnspecified = true;
        options.ApiVersionReader = ApiVersionReader.Combine(
            new UrlSegmentApiVersionReader(),
            new QueryStringApiVersionReader("version"),
            new HeaderApiVersionReader("X-Version")
        );
    });
}

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1.0")]
[ApiVersion("2.0")]
public class UsersController : ControllerBase
{
    [HttpGet]
    [MapToApiVersion("1.0")]
    public async Task<IActionResult> GetUsersV1()
    {
        // Version 1 implementation
    }

    [HttpGet]
    [MapToApiVersion("2.0")]
    public async Task<IActionResult> GetUsersV2()
    {
        // Version 2 implementation
    }
}
```

### API Documentation Security
```csharp
// Secure Swagger configuration
public void ConfigureServices(IServiceCollection services)
{
    services.AddSwaggerGen(c =>
    {
        c.SwaggerDoc("v1", new OpenApiInfo { Title = "My API", Version = "v1" });
        
        // JWT authentication for Swagger
        c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
        {
            Description = "JWT Authorization header using the Bearer scheme.",
            Name = "Authorization",
            In = ParameterLocation.Header,
            Type = SecuritySchemeType.ApiKey,
            Scheme = "Bearer"
        });

        c.AddSecurityRequirement(new OpenApiSecurityRequirement
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "Bearer"
                    }
                },
                new string[] {}
            }
        });

        // Hide endpoints in production
        if (!_environment.IsDevelopment())
        {
            c.DocumentFilter<HideInProductionFilter>();
        }
    });
}

// Only enable Swagger in development
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    if (env.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }
}
```

## Compliance Requirements

### GDPR Compliance
- [ ] **Data mapping**: Identify all personal data collected and processed
- [ ] **Consent management**: Implement consent collection and withdrawal
- [ ] **Right to access**: Provide users access to their personal data
- [ ] **Right to rectification**: Allow users to correct their data
- [ ] **Right to erasure**: Implement data deletion functionality
- [ ] **Data portability**: Export user data in machine-readable format
- [ ] **Privacy by design**: Build privacy considerations into system design
- [ ] **Data breach notification**: Implement breach detection and notification

```csharp
// GDPR compliance example
public class GdprService
{
    public async Task<UserDataExport> ExportUserDataAsync(int userId)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        var orders = await _orderRepository.GetByUserIdAsync(userId);
        var activities = await _activityRepository.GetByUserIdAsync(userId);

        return new UserDataExport
        {
            PersonalData = user,
            Orders = orders,
            Activities = activities,
            ExportDate = DateTime.UtcNow
        };
    }

    public async Task DeleteUserDataAsync(int userId)
    {
        // Anonymize or delete user data
        await _userRepository.AnonymizeUserAsync(userId);
        await _orderRepository.AnonymizeUserOrdersAsync(userId);
        await _activityRepository.DeleteUserActivitiesAsync(userId);
    }
}
```

### HIPAA Compliance (Healthcare)
- [ ] **Administrative safeguards**: Access controls, workforce training
- [ ] **Physical safeguards**: Facility access controls, workstation security
- [ ] **Technical safeguards**: Encryption, audit logs, access controls
- [ ] **Business associate agreements**: Third-party vendor compliance
- [ ] **Audit trails**: Comprehensive logging of PHI access

### SOX Compliance (Financial)
- [ ] **Change management**: Controlled deployment processes
- [ ] **Access controls**: Segregation of duties, approval workflows
- [ ] **Audit trails**: Comprehensive transaction logging
- [ ] **Data integrity**: Financial data accuracy and completeness
- [ ] **Backup and recovery**: Reliable data backup and recovery procedures

## Security Testing

### Automated Security Testing
```csharp
// Security-focused unit tests
[Test]
public async Task Login_WithSqlInjectionAttempt_ShouldNotSucceed()
{
    var maliciousInput = "admin'; DROP TABLE Users; --";
    var result = await _authService.AuthenticateAsync(maliciousInput, "password");
    
    Assert.IsNull(result);
    
    // Verify database integrity
    var userCount = await _context.Users.CountAsync();
    Assert.Greater(userCount, 0, "Users table should not be dropped");
}

[Test]
public void PasswordHashing_ShouldUseSecureAlgorithm()
{
    var password = "TestPassword123!";
    var hashedPassword = _passwordHasher.HashPassword(password);
    
    Assert.IsTrue(_passwordHasher.VerifyPassword(password, hashedPassword));
    Assert.IsFalse(hashedPassword.Contains(password), "Password should not appear in hash");
    Assert.Greater(hashedPassword.Length, 50, "Hash should be sufficiently long");
    
    // Verify it uses bcrypt, Argon2, or PBKDF2
    Assert.IsTrue(hashedPassword.StartsWith("$2") || hashedPassword.StartsWith("$argon2") || hashedPassword.Contains("$"));
}
```

### Penetration Testing
- [ ] **OWASP ZAP**: Automated vulnerability scanning
- [ ] **Burp Suite**: Manual security testing
- [ ] **Static Analysis**: SonarQube, CodeQL, Veracode
- [ ] **Dynamic Analysis**: Runtime security testing
- [ ] **Third-party audits**: External security assessments

### Security Monitoring
```csharp
// Security event logging
public class SecurityEventLogger
{
    private readonly ILogger<SecurityEventLogger> _logger;

    public void LogSecurityEvent(SecurityEventType eventType, string userId, string details, HttpContext context)
    {
        var securityEvent = new
        {
            EventType = eventType.ToString(),
            UserId = userId,
            IpAddress = context.Connection.RemoteIpAddress?.ToString(),
            UserAgent = context.Request.Headers.UserAgent.ToString(),
            Timestamp = DateTime.UtcNow,
            Details = details
        };

        _logger.LogWarning("Security Event: {@SecurityEvent}", securityEvent);
        
        // Send to SIEM system if configured
        await _siemService.SendEventAsync(securityEvent);
    }
}

public enum SecurityEventType
{
    LoginFailure,
    AccountLockout,
    PasswordChange,
    PrivilegeEscalation,
    UnauthorizedAccess,
    DataAccess,
    ConfigurationChange
}
```

## Incident Response

### Security Incident Procedures
1. **Detection**: Automated monitoring, user reports, security scans
2. **Assessment**: Determine scope, impact, and severity
3. **Containment**: Isolate affected systems, prevent spread
4. **Eradication**: Remove threat, fix vulnerabilities
5. **Recovery**: Restore systems, monitor for recurring issues
6. **Lessons Learned**: Document incident, improve procedures

### Emergency Response Plan
- [ ] **Contact list**: Security team, management, external experts
- [ ] **Communication plan**: Internal and external notifications
- [ ] **System isolation**: Procedures to isolate compromised systems
- [ ] **Data preservation**: Forensic evidence collection
- [ ] **Recovery procedures**: System restoration and validation
- [ ] **Post-incident review**: Analysis and improvement recommendations

Remember: Security is an ongoing process, not a one-time implementation. Regular reviews, updates, and testing are essential for maintaining a secure application.