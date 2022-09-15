param env string
param location string

var vNetName = 'Burke-${env}-VNet'

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  parent: vnet
  name: 'default'
  properties: {
    addressPrefix: '10.0.0.0/24'
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'eastus'
          'westus'
        ]
      }
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.Sql'
        locations: [
          'eastus'
        ]
      }
    ]
    delegations: [
      {
        name: 'dlg-postgres'
        properties: {
          serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
        }
      }
    ]
  }
}

output id string = vnet.id
output subnetId string = subnet.id
