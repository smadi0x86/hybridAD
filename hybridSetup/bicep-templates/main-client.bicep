/// Specify the Virtual machine parameters

@description('Name of the Virtual Machine')
param VirtualMachineName string = 'Hybrid-Client01'

@description('Location setting') 
param location string = resourceGroup().location

@description('Size of the Virtual Machine')
param size string = 'Standard_B2s'

@description('Admin username for the VM')
param adminUsername string

@description('Admin password for the VM')
@secure()
param adminPassword string

/// Specify the Vnet parameters



@description('Name of the Virtual Network')
param vnetName string = 'VirtualNetwork01'

@description('Name of the Subnet')
param subnetName string = 'Subnet01'

@description('Resource Group of the VNet') 
param vnetResourceGroup string


/// Deploying the network components


module networkModule 'network-client.bicep' = {
  name: 'networkDeployment'
  params: {
    VirtualMachineName: VirtualMachineName
    location: location
    vnetResourceGroup: vnetResourceGroup
    vnetName: vnetName 
    subnetName: subnetName
  
  }
}


/// Deploing the virtual machine

module vmModule 'vm-client.bicep' = {
  name: 'vmDeployment'
  params: {
    VirtualMachineName: VirtualMachineName
    location: location
    size: size
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicId: networkModule.outputs.networkInterface
  }
}
