# Active Directory Fundamentals

## Why Active Directory Exists

Before Active Directory, Windows NT used a flat domain model with limited scalability and management capabilities. Active Directory (introduced in Windows 2000) replaced this by providing a hierarchical, scalable directory service based on LDAP, Kerberos, and DNS.

AD allows:

- Centralized identity management (users, computers, groups)
- Authentication (via Kerberos v5)
- Authorization (via group memberships, ACLs)
- Directory-based configuration management (via Group Policy)

## Core AD Architecture

### 1. **Directory Database**

- The AD database (`NTDS.dit`) stores all directory objects (users, groups, OUs, etc.).
- Located at: `C:\Windows\NTDS\NTDS.dit` on each Domain Controller.
- Uses Extensible Storage Engine (ESE) for indexing and replication.

### 2. **Forest**

- Top-level AD container.
- Defines a single instance of AD — its own global catalog, configuration, and schema.
- Multiple domains can exist in a forest.
- One forest = one security boundary.

### 3. **Domain**

- Logical partition in a forest.
- Each domain has:
  - Unique DNS name (e.g., corp.local)
  - Its own objects (users, computers, etc.)
  - Its own domain controllers
- Trusts are established between domains for authentication.

### 4. **Organizational Unit (OU)**

- Logical containers inside domains.
- Used to delegate permissions and apply Group Policies.
- OUs can be nested.

### 5. **Sites**

- Represent physical/logical network boundaries.
- Affect replication topology (based on IP subnets).
- Used to control logon traffic and GPO replication.

---

## Active Directory Protocols

### LDAP (Lightweight Directory Access Protocol)

- Port 389 (LDAP), 636 (LDAPS).
- Used by applications and clients to query/update AD.
- AD supports LDAPv3, with proprietary Microsoft extensions.

### Kerberos

- Primary authentication protocol.
- Relies on Key Distribution Center (KDC) on Domain Controllers.
- Uses tickets (`TGT`, `TGS`) to authenticate users/services.

### NTLM

- Legacy fallback when Kerberos fails.
- Uses challenge-response; vulnerable to relay attacks.

### DNS

- AD is tightly integrated with DNS.
- Domain Controllers register SRV records (e.g., `_ldap._tcp.dc._msdcs.domain.com`).
- Clients use these to locate services.

---

## Logical vs. Physical Structure

| Component           | Logical                                     | Physical                          |
| ------------------- | ------------------------------------------- | --------------------------------- |
| Forests/Domains/OUs | Logical — hierarchy of trust and delegation | N/A                               |
| Sites               | N/A                                         | Physical topology for replication |
| Domain Controllers  | Logical & Physical                          | The actual server running AD DS   |

---

## Domain Controllers (DCs)

- Host the NTDS service and the AD database.
- All DCs within a domain replicate changes (multi-master).
- One DC holds the **PDC Emulator**, **RID Master**, **Infrastructure Master**, **Schema Master**, and **Domain Naming Master** FSMO roles.

---

## FSMO Roles (Flexible Single Master Operations)

| Role                  | Scope       | Description                                               |
| --------------------- | ----------- | --------------------------------------------------------- |
| Schema Master         | Forest-wide | Controls schema modifications.                            |
| Domain Naming Master  | Forest-wide | Adds/removes domains in the forest.                       |
| RID Master            | Domain-wide | Allocates RID pools to DCs.                               |
| PDC Emulator          | Domain-wide | Legacy NT BDC compatibility, password updates, time sync. |
| Infrastructure Master | Domain-wide | Updates cross-domain references.                          |

---

## SYSVOL & Netlogon

- `SYSVOL` is shared folder on DCs: `C:\Windows\SYSVOL\domain`
  - Stores GPOs, login scripts, etc.
- Replicated using DFS-R or (legacy) FRS.
- `Netlogon` is used for legacy logon scripts.

---

## Replication

- AD uses **multi-master replication**.
- Replication is triggered by updates or periodic polling.
- Sites control replication cost/schedules via site links.
- AD uses:
  - **USNs (Update Sequence Numbers)**
  - **High-Watermark Vectors**
  - **Invocation IDs**
  - **GUIDs for each object**

---

## Authentication Flow (Simplified)

1. Client contacts DNS to find DC.
2. Client sends logon request via Kerberos (or NTLM fallback).
3. DC (KDC) issues TGT (Ticket Granting Ticket).
4. Client requests service ticket (TGS) from KDC.
5. Client presents ticket to target service.

---

Next: [On-Prem AD Core](02-on-prem-AD-core.md)
