 # Base64-encoded Immutable ID
 $base64ImmutableID = "IS4/w9VY/k+f4xotJfp+KQ=="

 # Decode the Base64 string into a byte array
 $decodedBytes = [Convert]::FromBase64String($base64ImmutableID)
 
 # Convert the decoded bytes to a hexadecimal string (for easy comparison)
 $decodedHexString = -join ($decodedBytes | ForEach-Object { $_.ToString("X2") })
 
 # The binary GUID to compare with (in hex format)
 $binaryGUID = "21 2E 3F C3 D5 58 FE 4F 9F E3 1A 2D 25 FA 7E 29"
 
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
  
 