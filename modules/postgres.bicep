param env string
param location string
param vNetSubnetId string

@secure()
param adminPW string

var postgresName = 'Postgres-Burke-${env}'

resource postgres 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: postgresName
  location: location
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
    size: '5120'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    storageProfile: {
      storageMB: 5120
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
      storageAutogrow: 'Enabled'
    }
    version: '11'
    sslEnforcement: 'Enabled'
    minimalTlsVersion: 'TLS1_2'
    infrastructureEncryption: 'Disabled'
    publicNetworkAccess: 'Enabled'
    createMode: 'Default'
    administratorLogin: 'burke'
    administratorLoginPassword: adminPW
  }

  resource vnetRule 'virtualNetworkRules@2017-12-01' = {
    name: 'AllowSubnet'
    properties: {
      virtualNetworkSubnetId: vNetSubnetId
      ignoreMissingVnetServiceEndpoint: true
    }
  }
}

/*
resource pgPrivateEndpoint 'Microsoft.DBforPostgreSQL/servers/privateEndpointConnections@2018-06-01' = {
  parent: postgres
  name: '${postgresName}-PrivateEndpoint'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'approved'
    }
  }
}
*/

resource firewallRules 'Microsoft.DBforPostgreSQL/servers/firewallRules@2017-12-01' = {
  name: '${postgres.name}/allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

output id string = postgres.id
