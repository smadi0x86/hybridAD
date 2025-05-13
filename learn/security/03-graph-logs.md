# Microsoft Graph Activity Logs Overview

## 1. Legacy vs Modern Modules Logging

### Legacy: `AzureAD` Module

- PowerShell cmdlets from the **AzureAD** module (e.g., `Get-AzureADUser`) do **not** generate detailed API logs.
- The only visibility is through **Sign-In Logs** — i.e., when the user authenticates, not when they run a specific command.
- This means no granular audit trail for what objects were modified or queried.

### Modern: `Microsoft.Graph` Module (SDK v1+)

- Uses **Microsoft Graph API**.
- Each request is represented in **AADGraphActivityLogs** (if legacy Graph endpoint) or future Graph audit logging tables.
- These logs enable detailed tracking of Graph-based operations.

> **Security Impact**:
> Previously, attackers could enumerate Entra ID objects (e.g., users/groups) without detection. With Microsoft Graph activity logs, **enumeration and access manipulation are now auditable**, eliminating that blind spot.

---

## 2. AADGraphActivityLogs Table

> 📌 Note: There's a **new diagnostic setting** called `AzureADGraphActivityLogs` (not `MicrosoftGraphActivityLogs`).
>
> 🔍 No official documentation on MSDN, but you can pull schema/data directly from:
> `https://api.loganalytics.io/v1/metadata` → search for `AADGraphActivityLogs`.
>
> This table captures **legacy Azure AD Graph API** calls, not Microsoft Graph. Still relevant for older apps/scripts and diagnostic auditing.

### Table Metadata

- **Name**: `AADGraphActivityLogs`
- **Type**: Microsoft-managed Log Analytics table
- **Time Column**: `TimeGenerated`

### Typical Query

```kql
AADGraphActivityLogs
| where TimeGenerated > ago(1d)
| where OperationName == "GetUser"
| project TimeGenerated, UserId, OperationName, ResultSignature, DurationMs
```

---

## 3. Key Columns Explained

| Column               | Type     | Description                                         |
| -------------------- | -------- | --------------------------------------------------- |
| `TimeGenerated`      | datetime | When the request was received                       |
| `OperationName`      | string   | API operation (e.g., `GetUser`, `DeleteGroup`)      |
| `OperationVersion`   | string   | API version (e.g., `1.6`)                           |
| `RequestMethod`      | string   | HTTP method (GET, POST, PATCH, DELETE)              |
| `ResultSignature`    | string   | HTTP result (e.g., `200`, `403`)                    |
| `AppId`              | string   | App making the request (e.g., Graph SDK)            |
| `UserId`             | string   | ID of the user executing the request                |
| `ServicePrincipalId` | string   | ID of the SP executing the request (if app context) |
| `Location`           | string   | Azure region of API execution                       |
| `ResponseSizeBytes`  | int      | Size of returned payload                            |
| `TokenIssuedAt`      | datetime | JWT issuance time                                   |
| `Roles`              | string   | Role claims in token                                |
| `SignInActivityId`   | string   | Cross-reference to Sign-In log                      |

---

## 4. Use Cases

- **Audit user access changes via Graph**
- **Correlate script-based changes to Entra objects**
- **Detect anomalies or abuse via repeated API requests**
- **Investigate service principal activity**

---

## 5. What's Changing?

- Microsoft is consolidating toward **Microsoft Graph logs** (not legacy AAD Graph).
- Graph PowerShell SDK uses **Microsoft Graph endpoints**, which are gradually gaining better visibility in `AuditLogs` and `SignInLogs`.
- **Legacy enumeration is no longer undetected** — every Microsoft Graph API call (including user enumeration, group lookups, and writes) is increasingly tracked and auditable.
- Always prefer the `Microsoft.Graph` PowerShell module over `AzureAD` or `MSOnline` going forward.
