# Hybrid Identity Concepts

## 1. Purpose and Philosophy

Hybrid identity links **on-prem Active Directory (AD DS)** with **Azure AD / Entra ID** to provide unified identity across:

- On-prem resources (NTFS, LDAP apps)
- Cloud services (Microsoft 365, Azure, SaaS)

### Identity Plane Unification

- Maintain a single identity per user
- Enable seamless auth (SSO) from anywhere
- Allow for centralized lifecycle management (HR-driven provisioning, automatic deprovisioning)

---

## 2. Sync Engine Internals (Microsoft Entra Connect)

### Sync Rules Engine

- **Inbound**: AD → Metaverse
- **Outbound**: Metaverse → Azure AD
- Declarative rule system: each rule defines attribute flow, precedence, join logic
- Metaverse = intermediate object layer (canonical view of identities)

### Core Services

- **MIISClient.exe**: GUI for sync rules
- **SyncRulesEditor**: manage precedence
- **Scheduler**: every 30 mins (default), PowerShell-controllable

### Sync Object Flow

1. AD object (user) matches filter rules
2. Flows into connector space (CS)
3. Evaluated for join/provision logic
4. Sent to metaverse
5. Outbound rules applied → exported to Azure AD connector

### Join Criteria

- Typically via `sourceAnchor` (default: base64 of `objectGUID`)
- Must remain immutable during object lifetime
- Changing it = cloud user becomes orphaned

---

## 3. Source of Authority

### Default: On-prem AD

- Azure AD marks synced objects as **read-only**
- Controlled via `DirSyncEnabled` flag and `onPremisesImmutableId`

### Writeback-enabled Scenarios

- Password writeback
- Group writeback (to AD)
- Device writeback (for hybrid AAD join)
- SSPR, cloud-to-AD via MIM or Azure AD Connect

### ImmutableId Mapping

- `onPremisesImmutableId` in Azure AD must match base64(`objectGUID`) in AD
- Do NOT change this manually unless re-stamping identity after forest migration

---

## 4. Password Synchronization (PHS)

- Default option for hybrid identity
- Hash of AD password hash is computed and sent to Azure AD
- SHA256 + per-tenant salt → sent via secure TLS channel
- Stored encrypted, validated by Azure AD STS at login

### Benefits

- No dependency on on-prem availability for cloud auth
- Supports Smart Lockout, Identity Protection
- Enables SSO on Windows via Seamless SSO

---

## 5. Pass-through Authentication (PTA)

- Passwords never stored in cloud
- Auth requests proxied to on-prem agent
- Agent validates user credentials via Win32 Logon API
- Response sent back to Azure AD

### Use Cases

- Enforce on-prem login policies
- Avoid PHS for regulatory or risk reasons

---

## 6. Federation (AD FS / SAML IdP)

- Azure AD delegates authentication to a trusted Identity Provider (e.g., AD FS)
- Uses WS-Federation or SAML
- `login.microsoftonline.com` redirects to on-prem IdP
- Token issued by IdP is validated by Azure AD STS

### Federation Metadata

- XML document describing endpoints, certs, claims
- Must stay current (token signing cert rotation)

---

## 7. Seamless SSO (SSSO)

- Uses special Kerberos ticket from on-prem DC
- Azure AD sign-in endpoint issues challenge
- Client responds with ticket encrypted to `AZUREADSSOACC$` account (created during setup)
- No prompt for password when domain-connected and inside corp network

---

## 8. Coexistence and Conversion

### Synced → Cloud-only User

- Use PowerShell to **convert user to cloud-managed**
- Required for AD decommission or tenant-to-tenant migration

### Cloud-only → Synced

- Must delete and recreate object in AD (careful: loses data)

---

## 9. Troubleshooting & Tools

### Tools

- `IdFix`: clean up AD before sync (detects duplicates, invalid UPNs, illegal characters)
- `miisclient.exe`: inspect connector space and metaverse in Entra Connect
- `Entra Connect Sync Service (ADSync)`: Windows service (`ADSync`) responsible for scheduled sync tasks
- `Entra Connect Wizard`: GUI tool to configure sync rules, filtering, staging mode, etc.
- `EntraConnectHealth.exe`: Agent for health monitoring of sync, ADFS, and PTA; reports to Entra Admin Center
- `Winlogbeat`: Open-source tool to ship logs from Windows servers to Elasticsearch.
- PowerShell:
  - `Get-MsolUser` (MSOnline – legacy)
  - `Get-AzureADUser` (AzureAD – legacy)
  - `Get-MgUser` (Microsoft Graph – current and recommended)`: Legacy and current cmdlets to query user objects and sync status in Azure AD.
- `Synchronization Service Manager`: Advanced diagnostic UI for sync engine with detailed logging and error states.
- `Event Viewer`: Look under `Applications and Services Logs → Directory Synchronization` for sync service errors.
- `Hybrid Identity Administrator Portal`: Admin tools in the Azure portal (`Azure AD → Azure AD Connect`) for health monitoring.

### Logs

- `Synchronization Service Manager` → detailed logs
- Azure portal → Audit Logs, Sign-in Logs
- Event Viewer: AAD Connect errors

---

## 10. Design Considerations

- Always define `sourceAnchor` early
- Avoid reusing objectGuids across forests
- Enable hybrid join or device registration for full MDM scenarios
- Never sync built-in accounts (Administrator, Guest)

---

Next: [Common Questions](06-common-questions.md)
