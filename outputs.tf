output "monitor_autoscale_settings_id" {
  description = "Map of id values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.id }
}
output "monitor_autoscale_settings_enabled" {
  description = "Map of enabled values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.enabled }
}
output "monitor_autoscale_settings_location" {
  description = "Map of location values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.location }
}
output "monitor_autoscale_settings_name" {
  description = "Map of name values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.name }
}
output "monitor_autoscale_settings_notification" {
  description = "Map of notification values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.notification }
}
output "monitor_autoscale_settings_predictive" {
  description = "Map of predictive values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.predictive }
}
output "monitor_autoscale_settings_profile" {
  description = "Map of profile values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.profile }
}
output "monitor_autoscale_settings_resource_group_name" {
  description = "Map of resource_group_name values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.resource_group_name }
}
output "monitor_autoscale_settings_tags" {
  description = "Map of tags values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.tags }
}
output "monitor_autoscale_settings_target_resource_id" {
  description = "Map of target_resource_id values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.target_resource_id }
}

