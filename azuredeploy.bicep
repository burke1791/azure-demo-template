@allowed([
  'Test'
  'Stage'
  'Prod'
])
param env string

param location string = resourceGroup().location

@secure()
param sqlAdminPassword string

var storageAccountName = 'burke2demo${toLower(env)}'

module storageAccount 'modules/storage.bicep' = {
  name: 'storageAccount'
  params: {
    location: location
    name: storageAccountName
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    env: env
    location: location
  }
}

module synapse 'modules/synapse.bicep' = {
  name: 'synapse'
  params: {
    env: env
    location: location
    sqlAdminPassword: sqlAdminPassword
    dataLakeUrl: storageAccount.outputs.endpoint
    dataLakeResourceId: storageAccount.outputs.resourceId
    vnetId: vnet.outputs.id
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    env: env
    synapsePrincipalId: synapse.outputs.principalId
    location: location
    subnetId: vnet.outputs.subnetId
  }
}

module postgres 'modules/postgres.bicep' = {
  name: 'postgres'
  params: {
    env: env
    location: location
    vNetSubnetId: vnet.outputs.subnetId
    adminPW: sqlAdminPassword
  }
}
