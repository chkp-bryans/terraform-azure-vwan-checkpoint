provider "azurerm" {
  features {}

  # azurerm 4.x requires an explicit subscription. Authenticate with `az login`.
  subscription_id = var.subscription_id
  use_cli         = true
}
