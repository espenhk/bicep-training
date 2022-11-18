@description('Azure regions to deploy to.')
param locations array = [
  'westeurope'
  'eastus2'
]

@secure()
@description('Admin login username for SQL Server.')
param sqlServerAdministratorLogin string

@secure()
@description('Admin login password for SQL Server.')
param sqlServerAdministratorLoginPassword string

module databases 'modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}]
