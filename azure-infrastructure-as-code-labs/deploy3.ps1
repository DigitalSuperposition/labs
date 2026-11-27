#SETUP VARIABLES
$location = "eastus"
$rgName   = "RG1"
$vnetName = "Vnet1"
$nsgName  = "Lab-NSG"
$tags     = @{ "Lab" = "CreateRG"; "Owner" = "Ammon" }

<# Connect and select the FIRST available subscription
Connect-AzAccount
$sub = Get-AzSubscription | Select-Object -First 1
$sub | Set-AzContext#>

#CREATE NSG
Write-Host "Creating NSG..." -ForegroundColor Cyan

$rdpRule = New-AzNetworkSecurityRuleConfig -Name "AllowRDP" -Priority 100 `
    -Access Allow -Direction Inbound -Protocol Tcp `
    -SourceAddressPrefix "Internet" -SourcePortRange "*" `
    -DestinationAddressPrefix "*" `
    -DestinationPortRange 3389

$httpsRule = New-AzNetworkSecurityRuleConfig -Name "AllowHTTPS" -Priority 110 `
    -Access Allow -Direction Inbound -Protocol Tcp `
    -SourceAddressPrefix "Internet" -SourcePortRange "*" `
    -DestinationAddressPrefix "*" `
    -DestinationPortRange @(80, 443)

$nsg = New-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -Location $location `
    -SecurityRules $rdpRule, $httpsRule   

#CREATE SUBNETS (Attach NSG)
Write-Host "Creating Subnets and VNet..." -ForegroundColor Cyan

$subnet1 = New-AzVirtualNetworkSubnetConfig `
    -Name "frontendSubnet" `
    -AddressPrefix "10.0.1.0/24" `
    -NetworkSecurityGroup $nsg

$subnet2 = New-AzVirtualNetworkSubnetConfig `
    -Name "BackendSubnet" `
    -AddressPrefix "10.0.2.0/24" `
    -NetworkSecurityGroup $nsg   

#CREATE VNET
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location `
    -AddressPrefix "10.0.0.0/16" -Subnet $subnet1, $subnet2 -Tag $tags

#DONE
Write-Host "SUCCESS! Lab 1 Complete." -ForegroundColor Green
$vnet | Select-Object Name, @{N="AddressSpace";E={$_.AddressSpace.AddressPrefixes}}, Subnets   