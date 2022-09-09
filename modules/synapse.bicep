param env string
param dataLakeUrl string
param dataLakeResourceId string

param location string = resourceGroup().location

@secure()
param sqlAdminPassword string

resource synapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: 'burke-demo-${toLower(env)}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      resourceId: dataLakeResourceId
      createManagedPrivateEndpoint: false
      accountUrl: dataLakeUrl
      filesystem: 'burke'
    }
    sqlAdministratorLogin: 'system'
    sqlAdministratorLoginPassword: sqlAdminPassword
    managedVirtualNetwork: 'default'
    publicNetworkAccess: 'Enabled'
  }
}

resource synapseFirewall 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: synapse
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

output principalId string = synapse.identity.principalId
