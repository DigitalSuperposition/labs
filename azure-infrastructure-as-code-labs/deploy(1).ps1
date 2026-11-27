# 1. SETUP VARIABLES (Changed RG Name to avoid conflict)
$rgName = "RG1-Fixed" 
$location = "eastus"
$subId = "af073888-c2e3-4b33-80d7-81208d0d4db1"
$vnetName = "Vnet1"
$nsgName = "Lab-NSG"

$tags = @{ "Lab" = "CreateRG"; "Owner" = "Ammon" }

# 2. LOGIN
Connect-AzAccount
Set-AzContext -SubscriptionId $subId

# 3. CREATE RESOURCE GROUP
Write-Host "Creating Resource Group..." -ForegroundColor Cyan
New-AzResourceGroup -Name $rgName -Location $location -Tag $tags

# 4. CREATE NSG (Fixed: Unique names and explicit SourceAddressPrefix)
Write-Host "Creating NSG..." -ForegroundColor Cyan

# RDP Rule
$rdpRule = New-AzNetworkSecurityRuleConfig -Name "AllowRDP" -Priority 100 `
    -Access Allow -Direction Inbound -Protocol Tcp `
    -SourceAddressPrefix "Internet" -SourcePortRange * -DestinationPortRange 3389

# HTTPS Rule (Fixed: Unique Name 'AllowHTTPS')
$httpsRule = New-AzNetworkSecurityRuleConfig -Name "AllowHTTPS" -Priority 110 `
    -Access Allow -Direction Inbound -Protocol Tcp `
    -SourceAddressPrefix "Internet" -SourcePortRange * -DestinationPortRange @(80, 443)

# Create the NSG with both rules
$nsg = New-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -Location $location `
    -SecurityRules $rdpRule, $httpsRule

# 5. CREATE SUBNET CONFIGS (Attach NSG here)
Write-Host "Creating Subnets and VNet..." -ForegroundColor Cyan
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name "frontendSubnet" -AddressPrefix "10.0.1.0/24" -NetworkSecurityGroup $nsg
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name "BackendSubnet" -AddressPrefix "10.0.2.0/24" -NetworkSecurityGroup $nsg

# 6. CREATE VNET
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location `
    -AddressPrefix "10.0.0.0/16" -Subnet $subnet1, $subnet2 -Tag $tags

# 7. DONE
Write-Host "SUCCESS! Lab 1 Complete." -ForegroundColor Green
$vnet | Select-Object Name, AddressSpace, Subnets   