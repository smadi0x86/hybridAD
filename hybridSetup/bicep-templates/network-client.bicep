@description('Name of the Virtual Machine')
param VirtualMachineName string

@description('Location for the Network Resources')
param location string

@description('Name of the Virtual Network')
param vnetName string

@description('Name of the Subnet')
param subnetName string

@description('Resource Group of the VNet')
param vnetResourceGroup string


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  parent: virtualNetwork
  name: subnetName
}



resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: '${VirtualMachineName}-IP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: '${VirtualMachineName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP_enable'
        properties: {
          description: 'Enable RDP connection'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: '${VirtualMachineName}-nic'
  location: location
  properties: {
    ipConfigurations: [ { 
      name: 'Ip_config' 
      properties: { 
        privateIPAllocationMethod: 'Dynamic' 
        subnet: { 
          id: subnet.id 
        } 
        publicIPAddress: { 
          id: publicIPAddress.id 
        } 
      } 
    } 
  ]
  networkSecurityGroup: {
    id: networkSecurityGroup.id
  }
  }
}

output networkInterface string = nic.id





