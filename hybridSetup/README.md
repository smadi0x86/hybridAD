# Hybrid Identity Setup

This repository contains the necessary Bicep files and PowerShell scripts to set up a hybrid identity lab using Entra Connect.

## Folder Structure

- `/bicep-scripts`: Contains Bicep templates for deploying infrastructure resources like the virtual network and servers.
- `/powershell-scripts`: Contains PowerShell scripts for configuring Active Directory and managing users.
- `/IDFix`: Contains the IDFix tool for synchronizing on-premises Active Directory with Entra ID.

## Setup Instructions

1. Deploy resources using Bicep.
2. Configure Active Directory and synchronize with Entra ID.
3. Run PowerShell scripts for domain controller and user management.

- Please check the `Guide-1.pdf` and `Guide-2.pdf` files for detailed instructions on how to set up the lab environment.

## Prerequisites

- Azure subscription with Entra ID access.
- PowerShell for script execution.

## Notes

- Make sure to disable/exclude MFA for the sync machine group on Entra ID users settings before syncing with Entra Connect.
- What is the link between Azure AD (AAD) and AD users? https://www.youtube.com/watch?v=Ziw9MClUfkc.
- Download Entra Connect Installer using this link: https://www.microsoft.com/en-us/download/details.aspx?id=47594
