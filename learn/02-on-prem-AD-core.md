# On-Prem Active Directory Core Concepts

## 1. AD Schema: The DNA of the Directory

- **Schema = blueprint** for all objects (user, group, computer, etc.)
- Two components:
  - **Classes**: define object types (e.g. `user`, `computer`, `group`)
  - **Attributes**: define fields on those objects (e.g. `sAMAccountName`, `memberOf`, `userPrincipalName`)
- Schema is **forest-wide**, stored in `CN=Schema,CN=Configuration,<forest root>`
- Extensible via **schema extension** (e.g. Exchange, SCCM, or custom)
- Backed by `NTDS.dit` and modified via tools like `ldifde`, `adsi edit`, or PowerShell

### Schema Naming Context (NC)

- AD has **three naming contexts**:
  - **Domain NC**: objects (users, groups, etc.)
  - **Configuration NC**: forest-wide config (sites, services, etc.)
  - **Schema NC**: object definitions

## 2. Security Identifiers (SIDs)

- Every object has a **SID**: unique ID used in ACLs
- Format: `S-1-5-21-<domain ID>-<RID>`
  - `S-1-5-21`: prefix for domain-based accounts
  - `<domain ID>`: unique per domain
  - `<RID>`: Relative Identifier (incremental, assigned by RID master)
- Users/groups keep same SID even if renamed
- Deleting/recreating user = new SID → old ACLs break

## 3. Global Catalog (GC)

- A GC is a **partial replica** of all domain objects in the forest
- Used for:
  - UPN logon (e.g. `user@domain.com`)
  - Universal group membership resolution
  - Forest-wide searches (Outlook GAL, etc.)
- Enabled via checkbox in `ntdsutil` or `Active Directory Sites and Services`
- Only replicates a **subset of attributes**

## 4. Replication Engine

- **Multi-master** (except FSMO roles)
- Each DC maintains:
  - **Invocation ID** (replica instance)
  - **High-watermark vector table** (tracks partners' last known USNs)
  - **Up-to-dateness vector**
- Updates use **USNs** (Update Sequence Numbers)
- Uses **change-notification** within sites (15 sec + 3 sec per partner)
- **Inter-site replication** uses schedules and site links
- **Conflict resolution**: higher USN wins, if tie → latest timestamp wins

## 5. Group Policy Engine (GPO)

- Stored in:
  - **AD (GPT)**: `CN=Policies,CN=System,...`
  - **SYSVOL (GPC)**: `\<domain>\SYSVOL\<domain>\Policies\{GUID}`
- Applied at: Site → Domain → OU → Object
- Precedence: Local → Site → Domain → OU (last applied wins, unless blocked/enforced)
- Processed by `gpsvc` on clients
- **Client-side extensions (CSEs)** handle specific settings (e.g. scripts, registry, software)

## 6. Trusts Deep Dive

- **Within Forest**:

  - Automatic 2-way transitive trusts between domains

- **External Trusts**:

  - Between two separate domains (not in same forest)
  - One-way or two-way, non-transitive

- **Forest Trusts**:

  - Between two separate forests
  - Transitive between root domains only

- **Shortcut Trusts**:

  - Manually created to speed up auth between child domains

- **Trust Auth Types**:
  - **Selective Authentication**: access must be explicitly granted
  - **Forest-wide Auth**: automatic access across trusted forest

## 7. Admin Boundaries (Security)

- **Forest = ultimate security boundary**
- Domain admins in one domain **can’t** control other domains
- But **Enterprise Admins** (forest-wide) can control everything
- Use **separate forests** when true isolation is needed (e.g. dev/prod)

## 8. SYSVOL Replication

- **DFS-R** (modern) or **FRS** (deprecated since Server 2008)
- Contents: GPOs, scripts, policies
- Must stay in sync, or GPO application breaks
- Health check: `dcdiag`, `repadmin /replsummary`, `gpresult`, `event viewer`

## 9. Authentication Mechanisms

- **Kerberos v5**

  - TGT → TGS → service
  - Uses service principal names (SPNs), clock sync required

- **NTLM v2**

  - Fallback if Kerberos fails or for local accounts
  - Vulnerable to relay attacks

- **Smart Card / Cert Auth**
  - Requires PKI infra (AD CS), mapped cert-to-user

## 10. Auditing & Logging

- Enable **Advanced Audit Policy** via GPO
- Key logs:
  - `Security`: logon events, privilege use
  - `Directory Service`: replication
  - `DNS Server`: query logs (if DNS on DC)
  - Use `auditpol.exe` to view effective policy
- Tools: `eventvwr`, `Sysmon`, `LAPS`, SIEMs (e.g. Sentinel)

---

Next: Azure AD core (`03-azure-AD-core.md`).
