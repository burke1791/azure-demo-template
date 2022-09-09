param location string = resourceGroup().location
param storageSKU string = 'Standard_LRS'
param name string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: name
  location: location
  sku: {
    name: storageSKU
  }
  tags: {
    displayName: name
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output endpoint string = storageAccount.properties.primaryEndpoints.dfs
output resourceId string = storageAccount.id
