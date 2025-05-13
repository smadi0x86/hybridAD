# Hybrid Active Directory & Entra ID Learning Series

This folder contains deep technical notes for mastering identity concepts across **Windows Active Directory**, **Azure AD (Entra ID)**, and **hybrid identity deployments**. It is designed as a study reference for engineers, architects, and admins who want to understand both on-prem and cloud-native identity systems at an advanced level.

> ⚠️ This is not official Microsoft documentation. Use it for learning, not production config baselines.

---

## Learn Overview

### Core

| File                        | Description                                                                                                          |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `01-AD-Fundamentals.md`     | Foundational concepts: forests, domains, OUs, and core architecture of on-prem AD                                    |
| `02-on-prem-AD-core.md`     | Deep internals: replication, schema, GPO, SID structures, trust types, and DC operations                             |
| `03-azure-AD-core.md`       | Technical breakdown of Entra ID (formerly Azure AD): tenant model, auth protocols, object schema, conditional access |
| `04-entra-id-governance.md` | Covers PIM, access reviews, lifecycle workflows, entitlement management with Microsoft Graph integration             |
| `05-hybrid-identity.md`     | Internals of Entra Connect sync engine, PTA, PHS, federation, and device join scenarios                              |
| `06-common-questions.md`    | Clarifies common identity questions and confusing concepts like join types, source authority, PIM vs permanent roles |

### Security

| File                          | Description                                                                                               |
| ----------------------------- | --------------------------------------------------------------------------------------------------------- |
| `01-security-fundamentals.md` | Security fundamental concepts for AD, Entra ID, and Hybrid Identity                                       |
| `02-sentinel.md`              | Technical deep dive into Microsoft Sentinel: KQL, incidents, detection rules, playbooks, SOAR integration |
| `03-graph-logs.md`            | Explains Microsoft Graph activity auditing, including what gets logged, and how PowerShell modules differ |
| `AADGraphActivityLogs.json`   | Full schema of the AADGraphActivityLogs table used for legacy Graph API monitoring                        |

---

## Why This Exists

Many tutorials oversimplify AD and Entra concepts. This repo focuses on:

- **Deep internals**: how things actually work under the hood
- **Hybrid complexity**: joining on-prem with cloud identity platforms
- **Operational readiness**: covers both administrative practice and security auditing
- **Tooling awareness**: integrates PowerShell, Graph, Sentinel, and Log Analytics knowledge

---

## Who Is This For?

- Identity engineers
- Cloud architects
- Security operations teams
- Learners targeting hybrid or enterprise-scale environments

---

## Coming Soon (TODO)

- GPO vs Intune: policy control evolution
- Cross-tenant sync and B2B scenarios
- Defender for Identity correlation with Entra ID
