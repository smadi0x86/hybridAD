 # Base64-encoded Immutable ID
 $base64ImmutableID = "2enwSEYun0+SJjAd1RIWqw==" # Place immutable ID of user from Entra ID

 # Decode the Base64 string into a byte array
 $decodedBytes = [Convert]::FromBase64String($base64ImmutableID)
 
 # Convert the decoded bytes to a hexadecimal string (for easy comparison)
 $decodedHexString = -join ($decodedBytes | ForEach-Object { $_.ToString("X2") })
 
 # The binary GUID to compare with (in hex format)
 $binaryGUID = "D9 E9 F0 48 46 2E 9F 4F 92 26 30 1D D5 12 16 AB" # Get on-prem user mS-DS-ConsistencyGuid attribute value from users -> name of user -> properties, make sure to enable view -> advanced features
 
 # Remove spaces and compare the decoded string with the binary GUID
 $binaryGUID = $binaryGUID -replace " ", ""
 
 # Output the results with clear labels
 Write-Host "Immutable ID (Base64 decoded to Hex): $decodedHexString"
 Write-Host "mS-DS-ConsistencyGUID (Raw Binary GUID): $binaryGUID"
 
 # Compare and give a result
 if ($decodedHexString -eq $binaryGUID) {
     Write-Host "The Immutable ID and the mS-DS-ConsistencyGUID are the same."
 } else {
     Write-Host "The Immutable ID and the mS-DS-ConsistencyGUID are different."
 }
