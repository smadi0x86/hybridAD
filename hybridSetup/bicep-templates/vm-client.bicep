@description('Name of the Virtual Machine')
param VirtualMachineName string = 'Hybrid-Client01'

@description('Location setting') 
param location string = resourceGroup().location

@description('Size for the Virtual Machine') 
param size string = 'Standard_B2s' 

@description('Admin username for the VM') 
param adminUsername string 
@description('Admin password for the VM') 
@secure() 
param adminPassword string

@description('Network Interface ID for the VM') 
param nicId string




resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: VirtualMachineName
  location: location
  identity: { 
    type: 'SystemAssigned' 
  }
  properties: {
    hardwareProfile: {
      vmSize: size
    }
    osProfile: {
      computerName: VirtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
       windowsConfiguration: {
          enableAutomaticUpdates: true
          provisionVMAgent: true
          patchSettings: {
            patchMode: 'AutomaticByOS'
          }
        }
    }
    storageProfile: {
      imageReference: { 
        publisher: 'MicrosoftWindowsDesktop' 
        offer: 'Windows-10' 
        sku: 'win10-22h2-pro-g2' 
        version: 'latest' 
      }
      osDisk: {
        osType: 'Windows'
        name: '${VirtualMachineName}_OsDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: { 
          storageAccountType: 'Standard_LRS' 
        }
      }
    dataDisks: [] 
    }

networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
   
      ]
    }
    
    diagnosticsProfile: { 
      bootDiagnostics: { 
        enabled: true 
      }
      
    }
    licenseType: 'Windows_Client'
  }
}
