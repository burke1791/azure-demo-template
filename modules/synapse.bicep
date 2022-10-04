param env string
param dataLakeUrl string
param dataLakeResourceId string

param location string = resourceGroup().location

@secure()
param sqlAdminPassword string

resource synapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: 'burkewarehouse-${toLower(env)}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      resourceId: dataLakeResourceId
      createManagedPrivateEndpoint: false
      accountUrl: dataLakeUrl
      filesystem: 'hyperproof'
    }
    sqlAdministratorLogin: 'system'
    sqlAdministratorLoginPassword: sqlAdminPassword
    managedVirtualNetwork: 'default'
    publicNetworkAccess: 'Enabled'
    managedVirtualNetworkSettings: {
      preventDataExfiltration: false
    }
  }
}

output principalId string = synapse.identity.principalId
