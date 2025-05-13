# Active Directory, Entra ID, and Hybrid Identity Common Questions

## ❓ What is the difference between Entra ID, Azure AD, and Windows AD?

- **Entra ID**: The new name for Azure Active Directory. A cloud-native identity platform for authentication, SSO, RBAC, and security policies for cloud apps and services.
- **Azure AD**: The original name of Entra ID. Nothing changed in functionality — the branding was updated in 2023.
- **Windows AD (Active Directory Domain Services)**: On-premises directory service using LDAP/Kerberos. Stores user accounts, groups, computers, GPOs, etc. Used for domain-joined networks.

## ❓ What is the "Identity" concept in Entra ID?

- **Identity**: Represents a user, group, or service principal in Entra ID.
- Each identity has a unique **Object ID** and can have multiple **userPrincipalNames** (UPNs).
- **Service Principal**: Represents an application or service in Entra ID. Used for app permissions and access control.
- **Group**: A collection of users or service principals. Used for role-based access control (RBAC) and group-based licensing.
- **Role**: A set of permissions assigned to users, groups, or service principals. Used for access control.

## ❓ What does it mean to "join" a device, and how is that different from Entra Connect?

- **Join** = associating a device with an identity directory (AD or Entra ID)

  - **AD Join**: Device becomes part of an on-prem Windows AD domain. Uses Kerberos/LDAP. Applies GPOs. Enables classic domain login.
  - **Azure AD Join**: Device joins Entra ID (cloud-only). Authenticates to cloud with Entra creds. Enforces Conditional Access, supports Intune policies.
  - **Hybrid Azure AD Join**: Device is joined to both AD and Entra ID. Enables legacy compatibility + modern cloud auth/CA/MDM.
  - **Device Registration**: Lightweight (via Workplace Join or Auth app). No domain control. Used for SSO and CA.

- **Entra Connect** = tool for syncing user/group objects between on-prem AD and Entra ID. It **has nothing to do with device join** — it synchronizes identity objects only.

## ❓ What is the difference between Entra ID and Entra ID B2C?

- **Entra ID**: For managing identities within an organization. Used for internal users and devices.
- **Entra ID B2C**: For managing customer identities. Used for external users (customers) to access applications. Supports social logins and custom policies.

## ❓ What is Entra Domain Services?

- A PaaS offering that provides a managed **domain controller** in Azure.
- Enables **legacy protocols** (LDAP, Kerberos, NTLM) for apps that require them — without deploying on-prem DCs.
- Does **not** expose full administrative rights (you don’t get Domain Admin).
- Ideal for legacy app compatibility in cloud-only environments.

## ❓ Do I need both AD and Entra ID?

- **Hybrid Identity** is common in enterprises that:
  - Have legacy systems requiring Windows AD
  - Adopt Microsoft 365 or Azure services
- **Cloud-only Entra ID** is possible if:
  - No legacy requirements
  - All users/devices/apps are modern/cloud-based

## ❓ What’s the difference between Azure AD Join, Hybrid Join, and Registration?

- **Azure AD Join**: Device is owned by org, joined directly to Entra ID. Used for cloud-first devices.
- **Hybrid Azure AD Join**: Device is joined to on-prem AD and registered in Entra ID. Common in hybrid setups.
- **Registration**: Lightweight, typically for BYOD. Used for MFA, SSO, Conditional Access, but not domain control.

## ❓ What is `mS-DS-ConsistencyGUID` and why does it matter?

- A stable attribute used as **sourceAnchor** during directory sync.
- Ensures object in on-prem AD matches cloud user object.
- Mapped to `onPremisesImmutableId` in Entra ID.
- Avoid using `objectGUID` directly for sourceAnchor in multi-forest/hybrid environments.

## ❓ Can I change the source of authority for a user?

- Yes:
  - **Synced → Cloud-only**: Use PowerShell to disconnect object and convert to cloud-managed.
  - **Cloud-only → Synced**: Requires deletion/recreation, or advanced matching techniques.

## ❓ How does password hash sync work? Is it secure?

- It syncs a **hash of the hash** of the AD password (with salt) to Azure AD.
- Passwords are never stored in plaintext.
- Used by default in Entra Connect and supports Identity Protection.

## ❓ What’s the difference between Conditional Access and Group Policy?

- **Group Policy**: On-prem device/user settings (registry, firewall, etc.). Applied via AD and SYSVOL.
- **Conditional Access**: Access control policy for cloud sign-ins. Evaluates identity, device state, location, risk, etc.

## ❓ Should I use PIM or permanent admin roles?

- Use **Privileged Identity Management (PIM)** for:
  - Just-in-time elevation
  - Approval/MFA workflows
  - Audit logs and role expiration
- Avoid standing admin access to follow least-privilege principle.

## ❓ How do access reviews help in Entra ID?

- Periodically validate who has access to what (groups, apps, roles).
- Can be auto-applied based on inactivity or external status.
- Critical for guest access governance and compliance.

## ❓ How does Seamless SSO differ from PTA and Federation?

| Method        | Password in Cloud?  | Real-Time Auth? | Infra Required            |
| ------------- | ------------------- | --------------- | ------------------------- |
| Password Hash | Yes (hashed)        | No              | Entra Connect only        |
| PTA           | No                  | Yes             | On-prem agent             |
| Federation    | No                  | Yes             | AD FS or SAML IdP         |
| Seamless SSO  | N/A (uses Kerberos) | No              | Domain-joined + SSO setup |

## ❓ How do I check which users are synced vs cloud-only?

- Use PowerShell:
  - `Get-MgUser -Property UserType, DirSyncEnabled`
  - Synced users have `DirSyncEnabled = True`

---

Next: Security Fundamentals (`security/01-security-fundamentals.md`)
