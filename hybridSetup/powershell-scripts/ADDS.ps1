# Define variables for AD DS and DNS configuration
# Update DomainName, DomainNetBIOSName, and Password with your settings
$Config = @{
    DatabasePath        = "C:\Windows\NTDS"
    DomainMode          = "WinThreshold"
    DomainName          = "yourdomain.local" # Replace with your domain name
    DomainNetBIOSName   = "yourdomain"       # Replace with your NetBIOS name
    ForestMode          = "WinThreshold"
    LogPath             = "C:\Windows\NTDS"
    SysVolPath          = "C:\Windows\SYSVOL"
    SafeModePassword    = "P@ssw0rd!"        # Replace with your secure password
}

# Install necessary features for AD DS, DNS, and GPMC
Write-Output "Installing AD DS, DNS, and GPMC features..."
Start-Job -Name InstallFeatures -ScriptBlock {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
    Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools
    Install-WindowsFeature -Name GPMC -IncludeAllSubFeature -IncludeManagementTools
} | Wait-Job

# Validate installed features
Write-Output "Validating installed features..."
Get-WindowsFeature | Where-Object { $_.InstallState -eq 'Installed' } | 
    Format-Table DisplayName, Name, InstallState

# Convert password to a secure string
$SecurePassword = ConvertTo-SecureString -String $Config.SafeModePassword -AsPlainText -Force

# Install a new AD forest with DNS
Write-Output "Creating new AD forest and configuring DNS..."
Install-ADDSForest `
    -DatabasePath $Config.DatabasePath `
    -DomainMode $Config.DomainMode `
    -DomainName $Config.DomainName `
    -SafeModeAdministratorPassword $SecurePassword `
    -DomainNetBIOSName $Config.DomainNetBIOSName `
    -ForestMode $Config.ForestMode `
    -InstallDns:$true `
    -LogPath $Config.LogPath `
    -SysvolPath $Config.SysVolPath `
    -Force:$true `
    -NoRebootOnCompletion:$false

Write-Output "Active Directory Domain Services and DNS installation complete."
