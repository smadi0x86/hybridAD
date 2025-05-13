# Azure AD (Microsoft Entra ID) Core Concepts

> Note: Azure AD is now Microsoft Entra ID. The core identity platform is unchanged; this file uses both terms interchangeably where appropriate.

## 1. Azure AD Tenant Architecture

- A **tenant** is a dedicated instance of the Azure AD service.
- Identified by a **Tenant ID (GUID)** and default domain (`<org>.onmicrosoft.com`).
- All objects (users, groups, apps, policies) exist within a tenant scope.
- Tenants are flat: **no OUs or domain trees** like on-prem AD.

### Key Directories

- Every Microsoft 365/Azure subscription is tied to exactly one Azure AD tenant.
- One tenant can manage:
  - Users and groups
  - Devices (Azure AD Join, registration)
  - Applications and service principals
  - Conditional Access policies
  - Roles and RBAC

## 2. Identity Objects

### Users

- Each user has:
  - `objectId`: immutable GUID
    - ⚠️ **Note:** While `objectId` is globally unique within a tenant, it is not stable across tenants or re-creations. It is not best practice to use it as a permanent identifier for hybrid or cross-forest scenarios.
    - ✅ Use `mS-DS-ConsistencyGUID` (stored in Azure AD as `onPremisesImmutableId`) as the **sourceAnchor** for identity correlation. This value is stable and intended for long-term cross-system identity matching.
  - `userPrincipalName` (UPN)
  - `mail`, `displayName`, etc.
  - `source`: `Cloud`, `DirSync`, or `External`
- Cloud users are native; DirSync users come from on-prem AD.
- Passwords:
  - Stored as salted hashes in Microsoft-controlled infra
  - Auth flows differ by source (see auth section)

### Groups

- Types:
  - **Security groups**: used in access control and app assignment
  - **Microsoft 365 groups**: includes mailbox, Teams, Planner, etc.
- Membership:
  - Static (manual)
  - Dynamic (attribute-based rules)

### Devices

- **Registered**: via Workplace Join (BYOD, personal)
- **Azure AD Joined**: corporate-owned Windows devices
- **Hybrid AAD Join**: on-prem AD joined + registered with Azure AD

## 3. Applications and Service Principals

### App Registration (Application Object)

- Defines:
  - Redirect URIs
  - Permissions (OAuth scopes)
  - Secrets/certs
- Resides in developer’s home tenant

### Service Principal

- Local tenant instantiation of an app
- Created automatically when app is used in a tenant
- Has its own `objectId`, role assignments, and credentials

## 4. Authentication Protocols

### Modern Protocols

- **OpenID Connect (OIDC)** – identity layer over OAuth 2.0
- **OAuth 2.0** – delegated authorization
- **SAML 2.0** – legacy web SSO
- **WS-Federation** – backward compatibility

### Token Types

- **ID Token** (OIDC): represents authenticated user
- **Access Token** (OAuth2): grants access to APIs
- **Refresh Token**: long-lived, used to obtain new tokens

### Common Flows

- **Authorization Code Flow** (web apps)
- **ROPC** (legacy, username/password direct)
- **Device Code Flow** (CLI, IoT)
- **Client Credentials Flow** (service-to-service)

Tokens are JWTs (RS256) signed by Microsoft keys; validate using public JWKs from `https://login.microsoftonline.com/common/discovery/keys`

## 5. Conditional Access Engine

### Decision Flow

1. Evaluate user context (identity, risk, location, device)
2. Match policy conditions
3. Apply controls (MFA, block, require compliant device)

### Signal Types

- User/group
- Application
- Device platform/state
- Sign-in risk (from Microsoft Defender)
- Location (IP-based)
- Client app (browser/native/legacy)

### Enforcements

- Require MFA
- Require compliant device
- Require hybrid join
- Block access
- Require Terms of Use

## 6. Role-Based Access Control (RBAC)

### Azure AD Roles

- Directory-level roles
- Examples:
  - Global Administrator
  - User Administrator
  - Conditional Access Administrator

### Role Assignment Model

- Role → Principal (user/group/service principal)
- Can be **permanent** or via **PIM (just-in-time)**
- Scoped to entire tenant or specific administrative unit

## 7. Directory Synchronization Flags

### Attributes

- `sourceAnchor`: unique ID linking cloud and on-prem user (typically `objectGUID`)
- `DirSyncEnabled`: true/false
- `onPremisesImmutableId`: base64 of `objectGUID` used as sourceAnchor
- `isSoftDeleted`: used in user recycle bin logic

### Object State

- Synced users: read-only in Azure AD for most attributes
- Writeback enabled: allows selective cloud → on-prem writes (password, group, device)

## 8. API Interfaces

### Microsoft Graph API

- RESTful API to interact with AAD/Entra ID
- Replaces legacy Azure AD Graph
- Scopes:
  - `User.Read`, `Directory.Read.All`, `Group.ReadWrite.All`, etc.
- Supports:
  - User/group CRUD
  - Role assignments
  - App registration
  - Sign-in logs, risk, etc.

### PowerShell Modules

- `AzureAD` (legacy)
- `AzureAD.Standard.Preview`
- `Microsoft.Graph` (recommended)

## 9. Auditing and Logs

- **Sign-in Logs**: protocol used, MFA result, client info, IP
- **Audit Logs**: directory changes (group membership, app consent, etc.)
- **Workbooks/KQL**: in Azure Monitor, Sentinel

## 10. MFA, SSPR, Identity Protection

- **MFA**:

  - Methods: App, SMS, voice
  - Policies: Per-user (legacy) vs Conditional Access

- **SSPR** (Self-Service Password Reset):

  - Can write back to on-prem AD (if enabled)

- **Identity Protection**:
  - Detects risky sign-ins, leaked credentials, etc.
  - Integrates with CA policies for auto-remediation

---

Next: Entra-specific governance (entitlement management, lifecycle workflows, PIM) (`04-entra-id-governance.md`).
