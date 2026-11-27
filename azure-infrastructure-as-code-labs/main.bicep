// ==========================================
// 1. PARAMETERS
// These accept values from your PowerShell script.
// ==========================================
param projectName string = 'iacDemo'
param deploymentLocation string = 'eastus'
param allowedRegions array = ['eastus', 'eastus2', 'centralus']
param resourceTags object = {
  Lab: 'CreateRG'
  User: 'Lab-user'
  Owner: 'Ammon'
  CostCenter: 'RND-001'
}

// ==========================================
// 2. VALIDATION
// Ensures the location passed from PowerShell is allowed.
// ==========================================
@assert(deploymentLocation in allowedRegions, 'Error: Deployment location is not in the allowed list.')

// ==========================================
// 3. RESOURCES
// (Empty intentionally. No resources are created.)
// ==========================================