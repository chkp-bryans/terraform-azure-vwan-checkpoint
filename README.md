# Azure Virtual WAN + Check Point CloudGuard NVA

Terraform for a Standard Azure Virtual WAN, an East US hub at the smallest routing capacity, and Check Point CloudGuard Network Security NVAs inside that hub.

## Architecture

- **`rg-vwan-east`**: Virtual WAN (`Standard`) and East US hub (`sku = Standard`, `virtual_router_auto_scale_min_capacity = 2` — 3 Gbps / 2,000 VMs).
- **Check Point managed-app RG**: Marketplace managed application from [`CheckPointSW/cloudguard-network-security/azure//modules/nva`](https://registry.terraform.io/modules/CheckPointSW/cloudguard-network-security/azure/latest/submodules/nva).
- **NVA**: 10 scale units (~8 Gbps NGTP, 2 gateway instances), Gaia **R82**, routing intent for Internet and private traffic.

The Check Point module is used in **existing-hub** mode (`vwan_hub_address_prefix = ""`) so this repo owns hub capacity instead of the module creating a second WAN/hub.

## Prerequisites

- Terraform **1.9+** and Azure CLI (`az`)
- An Azure identity (your user or a group) with **Contributor** and **User Access Administrator** on the subscription. The Check Point module assigns a Reader role on the hub and a Public IP Join role.
- Check Point Marketplace offer `cp-vwan-managed-app` / plan `vwan-app` (the module accepts terms)
- SIC key (8–30 alphanumeric)
- SSH public key for gateway admin
- Two Smart-1 Cloud tokens (instances A and B) from [SK180501](https://support.checkpoint.com/results/sk/sk180501)

## Authenticate with Azure CLI

Terraform uses `az login`. You do **not** need a Service Principal `client_id` / `client_secret`.

```bash
az login
az account set --subscription "<subscription-id-or-name>"
az account show --query id -o tsv
```

Put that subscription ID in `infra/terraform.tfvars` as `subscription_id`. azurerm 4.x requires it even with CLI auth.

Your login session must still be valid when you run `terraform plan` / `apply`. The Check Point module calls `az account get-access-token` for Marketplace image lookup.

The Check Point module declares `client_id`, `client_secret`, and `tenant_id` as required inputs. This repo passes empty strings for those so the nested providers fall back to Azure CLI. Leave them unset.

Unset any leftover `ARM_CLIENT_ID` / `ARM_CLIENT_SECRET` environment variables so they do not override CLI auth.

## Deploy

```bash
az login
az account set --subscription "<subscription-id-or-name>"

cd infra
cp terraform.tfvars.example terraform.tfvars
# set subscription_id, sic_key, admin_ssh_public_key, and Smart-1 Cloud tokens
terraform init
terraform plan
terraform apply
```

Hub-only create is typically 5–7 minutes. Hub plus the Check Point managed application is often 30+ minutes and incurs NVA infrastructure-unit cost. Do not apply until those costs are acceptable.

## Destroy

Before `terraform destroy`, delete the hub **routing intent** in the Azure portal if destroy fails on that resource. Check Point documents this limitation.

NVA scale units do not autoscale. Changing from 10 later requires a new managed application and a routing-intent cutover.

## Layout

```
infra/
  versions.tf
  providers.tf
  variables.tf
  vwan.tf
  checkpoint.tf
  outputs.tf
  terraform.tfvars.example
```
