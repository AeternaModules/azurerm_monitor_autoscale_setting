resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_settings" {
  for_each = var.monitor_autoscale_settings

  location            = each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  target_resource_id  = each.value.target_resource_id
  enabled             = each.value.enabled
  tags                = each.value.tags

  dynamic "profile" {
    for_each = each.value.profile
    content {
      capacity {
        default = profile.value.capacity.default
        maximum = profile.value.capacity.maximum
        minimum = profile.value.capacity.minimum
      }
      dynamic "fixed_date" {
        for_each = profile.value.fixed_date != null ? [profile.value.fixed_date] : []
        content {
          end      = fixed_date.value.end
          start    = fixed_date.value.start
          timezone = fixed_date.value.timezone
        }
      }
      name = profile.value.name
      dynamic "recurrence" {
        for_each = profile.value.recurrence != null ? [profile.value.recurrence] : []
        content {
          days     = recurrence.value.days
          hours    = recurrence.value.hours
          minutes  = recurrence.value.minutes
          timezone = recurrence.value.timezone
        }
      }
      dynamic "rule" {
        for_each = profile.value.rule != null ? profile.value.rule : []
        content {
          metric_trigger {
            dynamic "dimensions" {
              for_each = rule.value.metric_trigger.dimensions != null ? [rule.value.metric_trigger.dimensions] : []
              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
            divide_by_instance_count = rule.value.metric_trigger.divide_by_instance_count
            metric_name              = rule.value.metric_trigger.metric_name
            metric_namespace         = rule.value.metric_trigger.metric_namespace
            metric_resource_id       = rule.value.metric_trigger.metric_resource_id
            operator                 = rule.value.metric_trigger.operator
            statistic                = rule.value.metric_trigger.statistic
            threshold                = rule.value.metric_trigger.threshold
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            time_grain               = rule.value.metric_trigger.time_grain
            time_window              = rule.value.metric_trigger.time_window
          }
          scale_action {
            cooldown  = rule.value.scale_action.cooldown
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
          }
        }
      }
    }
  }

  dynamic "notification" {
    for_each = each.value.notification != null ? [each.value.notification] : []
    content {
      dynamic "email" {
        for_each = notification.value.email != null ? [notification.value.email] : []
        content {
          custom_emails                         = email.value.custom_emails
          send_to_subscription_administrator    = email.value.send_to_subscription_administrator
          send_to_subscription_co_administrator = email.value.send_to_subscription_co_administrator
        }
      }
      dynamic "webhook" {
        for_each = notification.value.webhook != null ? [notification.value.webhook] : []
        content {
          properties  = webhook.value.properties
          service_uri = webhook.value.service_uri
        }
      }
    }
  }

  dynamic "predictive" {
    for_each = each.value.predictive != null ? [each.value.predictive] : []
    content {
      look_ahead_time = predictive.value.look_ahead_time
      scale_mode      = predictive.value.scale_mode
    }
  }
}

