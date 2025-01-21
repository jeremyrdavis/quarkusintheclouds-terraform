data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration" "appconf" {
  name                = var.app_config_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"
  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}

resource "azurerm_app_configuration_key" "key_one" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                  = "myKeyOne"
  value                = "qaz1"
}

resource "azurerm_app_configuration_key" "key_two" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                  = "myKeyTwo"
  value                = "qaz2"
  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}
