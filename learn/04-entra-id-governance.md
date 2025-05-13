# Microsoft Entra ID – Identity Governance Deep Technical Core

## 1. Overview

Entra ID Governance expands Azure AD's core identity management to include access lifecycle, compliance, and least-privilege enforcement across cloud and hybrid environments.

---

## 2. Entitlement Management

### Concepts

- **Access Package**: Bundle of groups, apps, SharePoint sites
- **Catalog**: Collection of access packages, managed by designated owners
- **Requests**: Self-service portal-based requests with workflows
- **Policies**: Define request conditions, approvals, expirations

### Access Package Internals

- Stored in Entra ID objects, retrievable via Microsoft Graph `/identityGovernance/entitlementManagement/accessPackages`
- Support conditional visibility based on user attributes (scoped access)

### Use Cases

- Automate onboarding (access package per department)
- Temporary project access with expiration
- Guest user onboarding with time limits

---

## 3. Lifecycle Workflows

### Trigger Events

- User created
- User disabled
- User added to group

### Actions

- Add user to group
- Send email (templated)
- Launch access package assignment
- Time-delayed tasks

### Architecture

- Backed by **workflowDefinition** and **workflowRun** objects
- Workflow logic stored in Entra ID; monitored via `/identityGovernance/lifecycleWorkflows` Graph path
- Supports conditions and filters based on user properties

---

## 4. Access Reviews

### Components

- Target: group, app, or role
- Reviewer: manager, group owner, selected users
- Recurrence: one-time or scheduled
- Outcomes: keep/remove, auto-apply or require confirmation

### Implementation

- Stored in `/identityGovernance/accessReviews/definitions`
- Evaluates:
  - Last sign-in
  - Role assignment changes
  - External/guest status

### Auto-Review Features

- **Recommendations**: Use sign-in activity
- **Auto-apply results**: Optional
- Integration with hybrid groups and PIM roles

---

## 5. Privileged Identity Management (PIM)

### Concepts

- Just-in-Time (JIT) role activation
- Role eligibility vs. active assignment
- Approval, MFA, justification workflows

### Key Objects

- `eligibleAssignment`: defines role eligibility
- `activeAssignment`: temporary activation
- `activationRequest`: user request to elevate

### Controls

- Role activation duration
- Require approval/MFA
- Notification on activation/deactivation
- Audit trail logging (via Azure AD logs and Graph)

### Roles Covered

- Azure AD directory roles (e.g., Global Admin)
- Azure RBAC roles (e.g., Subscription Owner)
- Custom roles supported

---

## 6. Integration and Monitoring

### Graph API Endpoints

- `/identityGovernance/`
- `/roleManagement/directory/`
- `/auditLogs/directoryAudits`
- `/reports/security`

### SIEM + Sentinel Integration

- Export audit logs via Diagnostic Settings to Log Analytics
- Query with KQL (`AuditLogs`, `SignInLogs`, `PIMAuditLogs`)

### Alerts

- PIM activation without justification
- Non-reviewed access packages
- Expired assignments not removed

---

## 7. Best Practices Summary

- Assign least-privilege via PIM + conditional access
- Automate onboarding/offboarding via lifecycle workflows
- Require periodic access reviews, especially for guests/admins
- Log all changes and monitor via Sentinel or Log Analytics
- Review access package design every 6–12 months

---

[Ready for hybrid identity internals next?](05-hybrid-identity.md)
