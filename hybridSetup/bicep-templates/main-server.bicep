/// Specify the Virtual machine parameters

@description('Name of the Virtual Machine')
param VirtualMachineName string = 'DC1'

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
@description('Vnet name')
param vnetName string = 'VirtualNetwork01'

@description('Vnet name')
param subnetName string = 'Subnet01'

@description('Resource Group of the VNet') 
param vnetResourceGroup string = 'Vnet'

/// Deploying the network components

module networkModule 'network-sever.bicep' = {
  name: 'networkDeployment'
  params: {
    VirtualMachineName: VirtualMachineName
    location: location
    vnetResourceGroup: vnetResourceGroup
    vnetName: vnetName
    subnetName: subnetName
    privateIpAddress: '10.1.1.5'
  }
}

/// Deploing the virtual machine

module vmModule 'vm-server.bicep' = {
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
