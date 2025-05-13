# HybridAD Playground

![image](https://github.com/user-attachments/assets/62067d10-3e9f-4f1e-93b0-6ce32f25a944)
![image](https://github.com/user-attachments/assets/82f93cd8-cb25-419d-8c59-8574e5973256)

This repository contains a collection of on-premise active directory and Entra ID projects all gathered in one place.

Every folder is an independent project, and you can use them separately. The projects are designed to help you learn and practice how to attack, defend and create on-premise AD and Entra ID environments then connect them together.

## Projects

- `cyberRange`: Terraform code to create different Azure security labs. The labs are designed to help you learn and practice various security concepts and techniques in a controlled environment.
- `hybridSetup`: Bicep files and PowerShell scripts to set up a hybrid identity lab using Entra Connect.
- `vulnerableEntraID`: A python tool that uses Terraform to create a vulnerable Azure AD tenant. It is designed to help you learn and practice various attack paths in a controlled environment.

## Recommendations

These projects are designed to be used together, and you can use them in any order. However, I recommend the following order to get the most out of them:

- Start with the `hybridSetup` project to setup an on-premise Active Directory and Entra ID environment then connect them together using Entra Connect.
- Use the `vulnerableEntraID` project to create a vulnerable Entra ID tenant and practice various attack paths.
- Use the `cyberRange` project to create different Azure security labs and practice various security concepts and techniques in a controlled environment.
