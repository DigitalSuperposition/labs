# ==============================================================================
# Azure Resource Group Deployment Script
# Purpose: Create 'RG1' with governance tags for the Skillsoft Lab
# ==============================================================================

# 1. Define Configuration
$resourceGroupName = "RG1"
$location = "eastus"
$subscriptionId = "f65f4dd8-40e0-49d8-8d15-837b4dd72d64" # Hardcoded from Lab Credentials

$tags = @{
    "Lab"        = "CreateRG"
    "User"       = "Lab-user"
    "Owner"      = "Ammon"
    "CostCenter" = "RND-001"
}

# 2. Connect to Azure
Write-Host "Connecting to Azure..." -ForegroundColor Cyan
Connect-AzAccount

# Set context to the specific Lab Subscription ID
Write-Host "Setting context to Subscription: $subscriptionId" -ForegroundColor Cyan
Set-AzContext -SubscriptionId $subscriptionId

# 3. Check & Create Resource Group
Write-Host "Checking for Resource Group '$resourceGroupName'..." -ForegroundColor Yellow
$existingGroup = Get-AzResourceGroup -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue

if ($existingGroup) {
    Write-Host "Resource Group exists. Updating tags..." -ForegroundColor Yellow
    Set-AzResourceGroup -ResourceGroupName $resourceGroupName -Tag $tags
}
else {
    Write-Host "Resource Group not found. Creating 'RG1'..." -ForegroundColor Green
    New-AzResourceGroup -ResourceGroupName $resourceGroupName -Location $location -Tag $tags
}

# 4. Final Verification
Write-Host "Deployment Complete. Verifying Resource Group..." -ForegroundColor Cyan
$finalGroup = Get-AzResourceGroup -Name $resourceGroupName | Select-Object ResourceGroupName, Location, Tags
$finalGroup | Format-List

Write-Host "Success! Resource Group '$resourceGroupName' is ready." -ForegroundColor Green