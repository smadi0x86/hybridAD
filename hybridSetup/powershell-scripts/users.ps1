##################################################
# Add Users to Active Directory
##################################################

# Set values for your environment
$numUsers = 5
$userPrefix = "userPrefix"
$passWord = "123P@ss0rd!"
$userDomain = "domain"

# Import the Active Directory module
Import-Module ActiveDirectory

# Convert the password to a secure string
$UserPass = ConvertTo-SecureString -AsPlainText $passWord -Force

# Add the users
for ($i = 1; $i -le $numUsers; $i++) {
    $newUser = "$userPrefix$i"
    $userPrincipalName = "$newUser@$userDomain"
    $firstName = "CloudUser"  # Replace with a desired generic first name
    $lastName = "$i"          # Use the index as a unique identifier for the last name
    $displayName = "$firstName $lastName" # Creates a readable display name like 'CloudUser 1'

    try {
        # Create the new AD user
        New-ADUser `
            -Name $newUser `
            -SamAccountName $newUser `
            -UserPrincipalName $userPrincipalName `
            -GivenName $firstName `
            -Surname $lastName `
            -DisplayName $displayName `
            -AccountPassword $UserPass `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpires $true `
            -Enabled $true

        Write-Output "User $displayName ($newUser) created successfully."
    } catch {
        Write-Error "Failed to create user $newUser. Error: $_"
    }
}

Write-Output "User creation process completed."
