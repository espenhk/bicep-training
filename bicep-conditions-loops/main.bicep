@description('Azure regions to deploy to.')
param locations array = [
  'westeurope'
  'eastus2'
  'eastasia'
]

@secure()
@description('Admin login username for SQL Server.')
param sqlServerAdministratorLogin string

@secure()
@description('Admin login password for SQL Server.')
param sqlServerAdministratorLoginPassword string

@description('IP address range for all VNets to use')
param virtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('Name and IP address range for each subnet in the VNets')
param subnets array = [
  {
    name: 'frontend'
    ipAddressRange: '10.10.5.0/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.10.10.0/24'
  }
]

var subnetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

module databases 'modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2022-05-01' = [for location in locations: {
  name: 'teddybear-${location}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: subnetProperties
  }
}]

output serverInfo array = [for i in range(0, length(locations)): {
  name: databases[i].outputs.serverName
  location: databases[i].outputs.location
  fullyQualifiedDomainName: databases[i].outputs.serverFullyQualifiedDomainName
}]
