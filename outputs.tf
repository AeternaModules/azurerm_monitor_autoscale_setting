output "monitor_autoscale_settings_id" {
  description = "Map of id values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.id if v.id != null && length(v.id) > 0 }
}
output "monitor_autoscale_settings_enabled" {
  description = "Map of enabled values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.enabled if v.enabled != null }
}
output "monitor_autoscale_settings_location" {
  description = "Map of location values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.location if v.location != null && length(v.location) > 0 }
}
output "monitor_autoscale_settings_name" {
  description = "Map of name values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.name if v.name != null && length(v.name) > 0 }
}
output "monitor_autoscale_settings_notification" {
  description = "Map of notification values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => one(v.notification) if v.notification != null && length(v.notification) > 0 }
}
output "monitor_autoscale_settings_predictive" {
  description = "Map of predictive values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => one(v.predictive) if v.predictive != null && length(v.predictive) > 0 }
}
output "monitor_autoscale_settings_profile" {
  description = "Map of profile values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.profile if v.profile != null && length(v.profile) > 0 }
}
output "monitor_autoscale_settings_resource_group_name" {
  description = "Map of resource_group_name values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.resource_group_name if v.resource_group_name != null && length(v.resource_group_name) > 0 }
}
output "monitor_autoscale_settings_tags" {
  description = "Map of tags values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.tags if v.tags != null && length(v.tags) > 0 }
}
output "monitor_autoscale_settings_target_resource_id" {
  description = "Map of target_resource_id values across all monitor_autoscale_settings, keyed the same as var.monitor_autoscale_settings"
  value       = { for k, v in azurerm_monitor_autoscale_setting.monitor_autoscale_settings : k => v.target_resource_id if v.target_resource_id != null && length(v.target_resource_id) > 0 }
}

