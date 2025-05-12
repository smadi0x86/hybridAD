##################################################
# Update User Principal Name (UPN) Domain
##################################################

# Define domains
$CurrentDomain = "<domain.local>"  # Current non-routable domain
$NewDomain = "<newdomain.com>"   # New routable domain

# Construct search pattern for the current domain
$SearchPattern = "*$CurrentDomain"

# Retrieve all users with the current UPN domain
$UsersToUpdate = Get-ADUser -Filter {UserPrincipalName -like $SearchPattern} `
    -Properties UserPrincipalName `
    -ResultSetSize $null

# Update UPNs for retrieved users
foreach ($User in $UsersToUpdate) {
    $UpdatedUPN = $User.UserPrincipalName.Replace($CurrentDomain, $NewDomain)
    Set-ADUser -Identity $User -UserPrincipalName $UpdatedUPN
    Write-Host "Updated UPN for user: $($User.SamAccountName) to $UpdatedUPN" -ForegroundColor Green
}

# Output completion message
Write-Host "UPN update process completed." -ForegroundColor Cyan
