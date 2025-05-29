---
name: Security Issue
about: Report a security vulnerability or concern
title: 'Security: [Brief Description]'
labels: security, needs-review, high-priority
assignees: ''
---

## ⚠️ Security Issue Summary
Brief description of the security concern or vulnerability.

## Severity Assessment
Select the appropriate severity level:
- [ ] **Critical** - Immediate fix required (RCE, Authentication bypass, Data breach)
- [ ] **High** - Fix within 24 hours (Privilege escalation, Sensitive data exposure)
- [ ] **Medium** - Fix within 1 week (XSS, CSRF, Information disclosure)
- [ ] **Low** - Fix in next release (Security hardening, Minor info leak)

## Affected Components
- **Project/Assembly**: [e.g., MyApp.Web.API]
- **Files/Classes**: [e.g., AuthController.cs, UserService.cs]
- **Endpoints/Functionality**: [e.g., /api/auth/login, User management]
- **.NET Version**: [e.g., .NET 8.0]
- **Packages**: [e.g., Microsoft.AspNetCore.Authentication.JwtBearer 8.0.0]

## Vulnerability Classification
Select all that apply:
- [ ] **Authentication Issues** (Bypass, weak auth, session management)
- [ ] **Authorization Issues** (Privilege escalation, access control bypass)
- [ ] **Input Validation** (Injection attacks, malformed input)
- [ ] **SQL Injection** (Direct SQL injection, blind SQL injection)
- [ ] **Cross-Site Scripting (XSS)** (Stored, reflected, DOM-based)
- [ ] **Cross-Site Request Forgery (CSRF)**
- [ ] **Information Disclosure** (Sensitive data exposure, stack traces)
- [ ] **Cryptographic Issues** (Weak encryption, key management)
- [ ] **Deserialization Vulnerabilities**
- [ ] **Path Traversal** (Directory traversal, file inclusion)
- [ ] **Denial of Service (DoS)**
- [ ] **Configuration Issues** (Insecure defaults, misconfigurations)
- [ ] **Dependency Vulnerabilities** (Known vulnerable packages)
- [ ] **Other**: [Specify]

## Attack Vector
Describe how this vulnerability could be exploited:
- **Attack Method**: [e.g., HTTP request, malicious input, social engineering]
- **Prerequisites**: [e.g., authenticated user, specific role, network access]
- **Complexity**: [e.g., Low - script kiddie, High - skilled attacker]

## Impact Assessment
What damage could result from exploitation:
- [ ] **Data Breach** (Access to sensitive user data)
- [ ] **System Compromise** (Server takeover, code execution)
- [ ] **Service Disruption** (DoS, system unavailability)
- [ ] **Reputation Damage** (Public disclosure impact)
- [ ] **Compliance Violation** (GDPR, HIPAA, SOX, etc.)
- [ ] **Financial Loss** (Direct costs, fines, business disruption)

## Reproduction Steps
**⚠️ Please provide minimal reproduction steps - do not include actual exploits**

1. 
2. 
3. 
4. 

## Proof of Concept
```csharp
// Example vulnerable code (sanitized)
// DO NOT include actual exploits or malicious payloads
public ActionResult Login(string username, string password)
{
    // Vulnerable pattern example
    var sql = $"SELECT * FROM Users WHERE Username='{username}' AND Password='{password}'";
    // ... rest of vulnerable implementation
}
```

## Expected Secure Behavior
Describe how the system should behave securely.

## Current Vulnerable Behavior
Describe the current insecure behavior without providing exploitation details.

## Environment Details
- **Operating System**: [e.g., Windows Server 2022]
- **Web Server**: [e.g., IIS 10, Kestrel]
- **Database**: [e.g., SQL Server 2022]
- **Load Balancer/Proxy**: [e.g., Nginx, Azure Application Gateway]
- **Authentication Provider**: [e.g., Azure AD, Identity Server]

## Error Messages/Logs
```
[Include relevant error messages with sensitive data redacted]
```

## Recommended Fix
Provide detailed recommendations for fixing the vulnerability:

### Immediate Actions
- [ ] [Short-term mitigation steps]
- [ ] [Disable affected functionality if critical]

### Permanent Solution
```csharp
// Example secure implementation
public async Task<ActionResult> Login(LoginRequest request)
{
    // Input validation
    if (!ModelState.IsValid)
        return BadRequest(ModelState);
    
    // Use parameterized queries
    var user = await _userService.AuthenticateAsync(request.Username, request.Password);
    // ... secure implementation
}
```

### Code Review Checklist
- [ ] Input validation implemented
- [ ] Output encoding applied
- [ ] Authentication/authorization verified
- [ ] SQL injection prevention confirmed
- [ ] XSS prevention implemented
- [ ] CSRF protection enabled
- [ ] Error handling doesn't leak information
- [ ] Logging implemented (without sensitive data)

## Testing & Verification
How to verify the fix works:

### Security Tests
- [ ] Unit tests for input validation
- [ ] Integration tests for authentication/authorization
- [ ] Penetration testing against fixed code
- [ ] Static code analysis scan
- [ ] Dynamic application security testing (DAST)

### Verification Steps
1. 
2. 
3. 

## References
- **OWASP**: [e.g., https://owasp.org/www-project-top-ten/]
- **CVE**: [e.g., CVE-2023-12345 if applicable]
- **Microsoft Security Advisory**: [if applicable]
- **Related Security Documentation**: [internal security guidelines]

## Communication Plan
- [ ] **Internal Team Notified** (Development, Security, Management)
- [ ] **Security Team Reviewed** (If separate security team exists)
- [ ] **Stakeholders Informed** (Product owners, compliance team)
- [ ] **Customer Communication Plan** (If customer-affecting)
- [ ] **Public Disclosure Timeline** (If vulnerability will be publicly disclosed)

## Remediation Timeline
- **Discovery Date**: [When was this discovered]
- **Initial Assessment**: [Date completed]
- **Fix Target Date**: [Based on severity]
- **Testing Complete**: [Target date]
- **Production Deployment**: [Target date]
- **Verification Complete**: [Target date]

## Security Review Checklist
- [ ] Vulnerability impact assessed
- [ ] Fix approach reviewed by security team
- [ ] Code changes peer reviewed
- [ ] Security testing completed
- [ ] Documentation updated
- [ ] Monitoring/alerting updated if needed
- [ ] Incident response procedures followed
- [ ] Lessons learned documented

## Additional Context
Any other context, screenshots (with sensitive data redacted), or information about the security issue.

---
**⚠️ IMPORTANT SECURITY NOTICE:**
- Keep this issue private until resolved
- Do not include actual exploits or attack payloads
- Redact all sensitive information (passwords, keys, personal data)
- Follow responsible disclosure practices