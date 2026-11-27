// =========================
// PARAMETERS
// =========================
param location string = resourceGroup().location

// Unique naming pattern using RG ID for deterministic uniqueness
param vnetName string = 'lab-vnet-${uniqueString(resourceGroup().id)}'
param subnetAppName string = 'app-subnet'
param subnetMgmtName string = 'mgmt-subnet'

// =========================
// RESOURCE: Virtual Network
// =========================
resource vnet 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
  }

  // Application Subnet
  resource subnetApp 'subnets' = {
    name: subnetAppName
    properties: {
      addressPrefix: '10.20.1.0/24'
    }
  }

  // Management Subnet
  resource subnetMgmt 'subnets' = {
    name: subnetMgmtName
    properties: {
      addressPrefix: '10.20.2.0/24'
    }
  }
}

// =========================
// OUTPUTS
// =========================
output appSubnetId string = vnet::subnetApp.id
output mgmtSubnetId string = vnet::subnetMgmt.id
output vnetId string = vnet.id
