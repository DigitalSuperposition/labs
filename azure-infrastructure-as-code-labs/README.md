# Azure Infrastructure as Code

Bicep templates, PowerShell scripts, and parameter files used across the lab repos.

## Contents

Yep, here's everything visible in that folder:

| # | File |
|---|---|
| 1 | `deploy(1).ps1` |
| 2 | `deploy.ps1` |
| 3 | `deploy3.ps1` |
| 4 | `main.bicep` |
| 5 | `README.md` |
| 6 | `StoreAB.bicep` |
| 7 | `vnet.bicep` |
| 8 | `vnet_parameters(1).json` |
| 9 | `vnet_parameters.json` |
| 10 | `vnet_template(1).json` |
| 11 | `vnet_template.json` |

## Usage

These files are referenced by the individual lab folders. Run via:

```
./deploy.ps1 -ResourceGroup "lab-rg" -Location "eastus"   
```

