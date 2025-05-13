# AD, Entra ID, and Hybrid Identity Security Fundamentals

## 1. Securing Active Directory (AD DS)

### Admin Tiering Model (Tier 0/1/2)

- **Tier 0**: Domain Controllers, schema admins, backup systems
- **Tier 1**: Servers and applications
- **Tier 2**: Workstations, user devices
- Accounts must never cross tiers. Admins of Tier 0 must not log in to Tier 1/2 assets.

### DC Hardening

- Run DCs on server core (no GUI)
- No internet access or browsing from DCs
- Enable Windows Defender Credential Guard
- Use **Read-Only Domain Controllers (RODCs)** in exposed locations (e.g., branch offices)

### Protocol Hardening

- Disable **LM/NTLM v1**, enable **LDAP Signing** and **Channel Binding**
- Use **AES Kerberos encryption** (disable RC4)
- Enable **LSA protection** (`RunAsPPL`)

### GPO Protection

- Delegate GPOs with GPMC, not by ACL hacking
- Use **starter GPOs** with baseline security
- Block GPO inheritance where needed, but use Enforced sparingly

---

## 2. Securing Azure AD / Entra ID

### Account Security

- Require **MFA** for all users; prefer phishing-resistant (FIDO2, Certificate, Authenticator App)
- Disable **legacy authentication protocols** (POP, IMAP, SMTP Basic, etc.)

### Role Security

- No permanent Global Administrators
- Use **Privileged Identity Management (PIM)** with just-in-time elevation
- Alert on PIM activations and excessive role assignments

### Conditional Access Best Practices

- Require compliant device or hybrid join for high-priv apps
- Use sign-in risk and user risk (from Entra Identity Protection)
- Block unknown locations, TOR/proxy IPs, and risky clients

### External Users (Guests)

- Enable access reviews for all B2B users
- Require terms of use and MFA for guests
- Use dynamic groups with strict filters

---

## 3. Securing Hybrid Identity

### Entra Connect Security

- Install sync service on a dedicated, hardened VM
- Remove local admin rights from the server after setup
- Block outbound internet from the sync server except required ports (443 to Microsoft endpoints)
- Avoid placing PTA agents in DMZ or proxy chains

### Password Hash Sync (PHS)

- Hashes are SHA256 of salted NT hash — irreversible
- Transport encrypted via TLS
- Avoid using reversible encryption in AD (legacy systems)

### Federation (AD FS)

- Rotate token signing certificates regularly
- Protect metadata endpoint
- Enforce strict claim issuance policies
- Harden AD FS proxy (WAP) — no unnecessary ports, logging enabled

---

## 4. Common Attack Paths

### Credential Theft Vectors

- LSASS memory scraping (e.g., Mimikatz)
- NTLM relay attacks
- Pass-the-Hash / Pass-the-Ticket
- Kerberoasting (SPNs with weak service account passwords)
- DCShadow (rogue replication)

### Azure/Cloud-Specific Attacks

- Token theft (refresh token reuse, browser token export)
- Consent phishing (malicious app registration)
- MFA fatigue attacks (push flooding)
- Privilege escalation via app roles or unused Graph permissions
- Abuse of automation identities (service principals, managed identities)

---

## 5. Modern Defense Strategies

### Zero Trust Model

- Never trust — always verify.
- All access is conditional (user + device + app + risk + location)
- Enforce policies _before_ allowing access (via CA)

### Identity Threat Detection

- Use Microsoft Entra ID Protection (risk-based CA, risky users)
- Integrate logs with Microsoft Sentinel or 3rd party SIEM
- Enable anomaly detection (e.g., Impossible Travel, unfamiliar sign-in)

### Deception and Active Defense

- **Honeytokens**: fake accounts or credentials monitored for access
- **Decoy SPNs**: fake services to detect kerberoasting
- **Fake DCs or OU objects**: attract DCShadow or DCSync attempts
- Monitor access to "decoy" sensitive groups

---

## 6. Learning and Practices

### Frameworks

- **MITRE ATT&CK for Enterprise (Windows + Cloud)**: enumerates all known AD/AAD attack tactics
- **Microsoft Security Best Practices**: Entra ID, Defender, M365, Sentinel
- **NIST 800-53**, **CIS Benchmarks** for Windows Server / AD

### Security Tools to Learn

- **BloodHound**: visualize AD attack paths
- **PingCastle**: AD security scoring
- **Purple Knight**: hybrid AD/AAD posture assessment
- **Microsoft Defender for Identity**: real-time attack detection in AD
- **Microsoft 365 Defender / Defender for Cloud Apps**: session control, threat analytics

### Blue Team Reading

- "The Defenders Playbook" – cloud + AD incident response
- "AD Security" (Sean Metcalf's blog)
- Microsoft Learn: SC-300, AZ-500 content tracks
- GitHub Projects: [AADInternals](https://github.com/Gerenios/AADInternals), [ROADtools](https://github.com/dirkjanm/ROADtools)

---

Next: [Microsoft Sentinel](02-sentinel.md)
