param env string
param dataLakeUrl string
param dataLakeResourceId string
param vnetId string

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
    managedVirtualNetworkSettings: {
      preventDataExfiltration: true
    }
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

resource synapseIntegrationRuntime 'Microsoft.Synapse/workspaces/integrationruntimes@2021-06-01' = {
  parent: synapse
  name: 'AzureIR-ManagedNVet'
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
        dataFlowProperties: {
          computeType: 'General'
          coreCount: 4
          timeToLive: 10
        }
      }
    }
    managedVirtualNetwork: {
      referenceName: 'default'
      type: 'ManagedVirtualNetworkReference'
      id: vnetId
    }
  }
}

output principalId string = synapse.identity.principalId
