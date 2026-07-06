output "monitor_autoscale_settings" {
  description = "All monitor_autoscale_setting resources"
  value       = azurerm_monitor_autoscale_setting.monitor_autoscale_settings
}
output "monitor_autoscale_settings_enabled" {
  description = "List of enabled values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.enabled]
}
output "monitor_autoscale_settings_location" {
  description = "List of location values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.location]
}
output "monitor_autoscale_settings_name" {
  description = "List of name values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.name]
}
output "monitor_autoscale_settings_notification" {
  description = "List of notification values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.notification]
}
output "monitor_autoscale_settings_predictive" {
  description = "List of predictive values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.predictive]
}
output "monitor_autoscale_settings_profile" {
  description = "List of profile values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.profile]
}
output "monitor_autoscale_settings_resource_group_name" {
  description = "List of resource_group_name values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.resource_group_name]
}
output "monitor_autoscale_settings_tags" {
  description = "List of tags values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.tags]
}
output "monitor_autoscale_settings_target_resource_id" {
  description = "List of target_resource_id values across all monitor_autoscale_settings"
  value       = [for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : v.target_resource_id]
}

