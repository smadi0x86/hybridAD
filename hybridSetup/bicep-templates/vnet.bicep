@description('Name of the Virtual Network')
param vnetName string = 'VirtualNetwork01'

@description('Address prefix for the Virtual Network')
param vnetAddressPrefix string = '10.1.0.0/16'

@description('Name of the Subnet')
param subnetName string = 'Subnet01'

@description('Address prefix for the Subnet')
param subnetAddressPrefix string = '10.1.1.0/24'

@description('Location for the Virtual Network')
param location string = resourceGroup().location

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [vnetAddressPrefix]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

output vnetId string = virtualNetwork.id
output subnetId string = virtualNetwork.properties.subnets[0].id
