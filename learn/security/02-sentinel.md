# Microsoft Sentinel Overview

## 1. What is Microsoft Sentinel?

- **Cloud-native SIEM and SOAR** on Azure.
- Integrates with Microsoft and third-party data sources.
- Built on **Azure Monitor / Log Analytics**.
- Real-time correlation, alerting, automation, and threat hunting.

---

## 2. Data Architecture

### Workspace

- Sentinel uses a **Log Analytics Workspace** to store logs.
- Data ingested via **Data Connectors** (built-in or custom).
- Tables are structured (e.g., `SecurityEvent`, `SignInLogs`, `AuditLogs`, `Heartbeat`).

### Kusto Query Language (KQL)

- Primary query language for detection rules, workbooks, and hunting.
- Example:

```kql
SigninLogs
| where ResultType != 0
| summarize FailedLogins=count() by IPAddress
```

---

## 3. Data Connectors

- Native support for:
  - Microsoft 365, Azure AD, Defender, Intune
  - Syslog (Linux), Common Event Format (CEF)
  - Amazon AWS, Okta, Palo Alto, Fortinet
- Custom ingestion:
  - REST API, Logic Apps, Event Hub, Azure Functions

### Agent Types

- **AMA (Azure Monitor Agent)**: modern agent for Linux/Windows
- **Log Analytics Agent (legacy)**

---

## 4. Detection & Analytics Rules

### Analytics Rule Types

- **Scheduled** (KQL queries, evaluated periodically)
- **Fusion** (ML-driven correlation from Microsoft)
- **Microsoft Security Incident Creation** (auto-raise incidents from Defender alerts)

### Rule Internals

- KQL + alert logic + threshold + actions
- Rules emit **Alerts**, which trigger **Incidents**

### Example Scheduled Rule

```kql
SigninLogs
| where Location != "US"
| where ResultType == 0
| summarize count() by UserPrincipalName
| where count_ > 3
```

---

## 5. Automation & SOAR (Playbooks)

### Playbook Engine

- Based on **Azure Logic Apps**
- Triggered by: Incident, Alert, Entity

### Common Actions

- Send email / Teams alert
- Disable user via Entra ID
- Run remediation script
- Open ServiceNow ticket

### Conditions & Flow

- Logic Apps are JSON workflows with connectors, conditionals, branches, retries

---

## 6. Workbooks & Dashboards

- Interactive dashboards built with KQL-backed visuals
- Used for:
  - Threat intelligence visualization
  - Identity sign-in risk views
  - Network anomaly reports
- Supports custom parameters, filters, cross-table visuals

---

## 7. Incident Handling

- **Incident = group of alerts** tied by entity/context
- Analyst actions:
  - Tag, assign, comment
  - Investigate (graph view)
  - Run playbook
  - Close/resolution tagging

---

## 8. Threat Intelligence (TI) Integration

- Built-in connector to Microsoft TI feeds
- Can ingest custom TI (STIX/TAXII, CSV, REST)
- TI entities (IP, URL, hash, domain) available in KQL via `ThreatIntelligenceIndicator` table

---

## 9. Advanced Hunting

- Ad hoc queries against log tables
- Combine multiple tables using joins/unions
- Enriched with Entity Mapping for user/device correlation

### Example

```kql
SigninLogs
| join kind=inner UniqueUserSessions on UserPrincipalName
| where Timestamp > ago(1h) and Location != "ExpectedRegion"
```

---

## 10. Best Practices

- Use **Analytics rule tuning** to reduce false positives
- Onboard **Identity, Endpoint, Network** sources
- Enable **UEBA** (User & Entity Behavior Analytics)
- Use **custom entity mapping** in rules for better correlation
- Integrate with Defender XDR stack

---

Next: Graph Activity Logs (`03-graph-logs.md`)
