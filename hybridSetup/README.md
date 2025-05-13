# Hybrid Identity Setup

This repository contains the necessary Bicep files and PowerShell scripts to set up a hybrid identity lab using Entra Connect.

## Folder Structure

- `/bicep-scripts`: Contains Bicep templates for deploying infrastructure resources like the virtual network and servers.
- `/powershell-scripts`: Contains PowerShell scripts for configuring Active Directory and managing users.
- `/IDFix`: Contains the IDFix tool for synchronizing on-premises Active Directory with Entra ID.
- `/hybridTools`: Contains utilities that interact with on-premises Active Directory configured as a hybrid setup.

## Setup Instructions

1. Deploy resources using Bicep.
2. Configure Active Directory and synchronize with Entra ID.
3. Run PowerShell scripts for domain controller and user management.

- Please check the `Guide-1.pdf` and `Guide-2.pdf` files for detailed instructions on how to set up the lab environment.

## Prerequisites

- Azure subscription with Entra ID access.
- PowerShell for script execution.

## Notes

- It's recommended to check `migration-best-practices.md` for azure identity management and ACL security best practices before proceeding with the setup.
- You may want to follow [this guide](https://github.com/MicrosoftDocs/entra-docs/blob/main/docs/identity/hybrid/cloud-sync/tutorial-basic-ad-azure.md) for a basic setup of a hybrid identity environment.
- Make sure to disable/exclude MFA for the sync machine group on Entra ID users settings before syncing with Entra Connect.
- What is the link between Azure AD (AAD) and AD users? https://www.youtube.com/watch?v=Ziw9MClUfkc.
- Download Entra Connect Installer using this link: https://www.microsoft.com/en-us/download/details.aspx?id=47594
- Always check the latest microsoft documentation for any updates:

  - https://github.com/MicrosoftDocs/entra-docs/tree/main/docs
  - https://github.com/MicrosoftDocs/entra-docs/tree/main/docs/identity/hybrid
  -
  - https://learn.microsoft.com/en-us/entra/
  - https://docs.microsoft.com/azure
  - https://github.com/MicrosoftDocs/azure-docs
  - https://github.com/MicrosoftDocs/azure-docs/tree/main/articles/security/fundamentals

- For any issues, additional features or questions, please open an issue in this repository.
