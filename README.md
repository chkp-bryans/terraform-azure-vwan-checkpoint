# Azure Virtual WAN + Check Point CloudGuard NVA

Terraform for a Standard Azure Virtual WAN, an East US hub at the smallest routing capacity, and Check Point CloudGuard Network Security NVAs inside that hub. A single `terraform plan` / `apply` creates all three.

## Architecture

- **Check Point managed-app RG** (`rg-checkpoint-managed-app`): Marketplace managed application from [`CheckPointSW/cloudguard-network-security/azure//modules/nva`](https://registry.terraform.io/modules/CheckPointSW/cloudguard-network-security/azure/latest/submodules/nva). In **new-VWAN** mode the same module also creates the Virtual WAN (`Standard`) and East US hub. Hub SKU/capacity are left unset, so `virtual_router_auto_scale_min_capacity` defaults to **2** (3 Gbps / 2,000 VMs).
- **NVA**: 10 scale units (~8 Gbps NGTP, 2 gateway instances), Gaia **R82**, routing intent for Internet and private traffic.

Pass a non-empty `hub_address_prefix` (default `10.0.0.0/23`) so the module creates WAN + hub instead of looking up an existing hub at plan time.

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

WAN, hub, and the Check Point managed application are created together. Apply is often 30+ minutes and incurs NVA infrastructure-unit cost. Do not apply until those costs are acceptable.

## Destroy

Before `terraform destroy`, delete the hub **routing intent** in the Azure portal if destroy fails on that resource. Check Point documents this limitation.

NVA scale units do not autoscale. Changing from 10 later requires a new managed application and a routing-intent cutover.

## Layout

```
infra/
  versions.tf
  providers.tf
  variables.tf
  checkpoint.tf
  outputs.tf
  terraform.tfvars.example
```
