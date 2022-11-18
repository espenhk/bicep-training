resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'toylaunchstorage-001'
  location: 'westus3'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}
