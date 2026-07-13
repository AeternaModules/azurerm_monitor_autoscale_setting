variable "monitor_autoscale_settings" {
  description = <<EOT
Map of monitor_autoscale_settings, attributes below
Required:
    - location
    - name
    - resource_group_name
    - target_resource_id
    - profile (block):
        - capacity (required, block):
            - default (required)
            - maximum (required)
            - minimum (required)
        - fixed_date (optional, block):
            - end (required)
            - start (required)
            - timezone (optional)
        - name (required)
        - recurrence (optional, block):
            - days (required)
            - hours (required)
            - minutes (required)
            - timezone (optional)
        - rule (optional, block):
            - metric_trigger (required, block):
                - dimensions (optional, block):
                    - name (required)
                    - operator (required)
                    - values (required)
                - divide_by_instance_count (optional)
                - metric_name (required)
                - metric_namespace (optional)
                - metric_resource_id (required)
                - operator (required)
                - statistic (required)
                - threshold (required)
                - time_aggregation (required)
                - time_grain (required)
                - time_window (required)
            - scale_action (required, block):
                - cooldown (required)
                - direction (required)
                - type (required)
                - value (required)
Optional:
    - enabled
    - tags
    - notification (block):
        - email (optional, block):
            - custom_emails (optional)
            - send_to_subscription_administrator (optional)
            - send_to_subscription_co_administrator (optional)
        - webhook (optional, block):
            - properties (optional)
            - service_uri (required)
    - predictive (block):
        - look_ahead_time (optional)
        - scale_mode (required)
EOT

  type = map(object({
    location            = string
    name                = string
    resource_group_name = string
    target_resource_id  = string
    enabled             = optional(bool)
    tags                = optional(map(string))
    profile = list(object({
      capacity = object({
        default = number
        maximum = number
        minimum = number
      })
      fixed_date = optional(object({
        end      = string
        start    = string
        timezone = optional(string)
      }))
      name = string
      recurrence = optional(object({
        days     = list(string)
        hours    = list(number)
        minutes  = list(number)
        timezone = optional(string)
      }))
      rule = optional(list(object({
        metric_trigger = object({
          dimensions = optional(list(object({
            name     = string
            operator = string
            values   = list(string)
          })))
          divide_by_instance_count = optional(bool)
          metric_name              = string
          metric_namespace         = optional(string)
          metric_resource_id       = string
          operator                 = string
          statistic                = string
          threshold                = number
          time_aggregation         = string
          time_grain               = string
          time_window              = string
        })
        scale_action = object({
          cooldown  = string
          direction = string
          type      = string
          value     = number
        })
      })))
    }))
    notification = optional(object({
      email = optional(object({
        custom_emails                         = optional(list(string))
        send_to_subscription_administrator    = optional(bool)
        send_to_subscription_co_administrator = optional(bool)
      }))
      webhook = optional(list(object({
        properties  = optional(map(string))
        service_uri = string
      })))
    }))
    predictive = optional(object({
      look_ahead_time = optional(string)
      scale_mode      = string
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        length(v.profile) >= 1 && length(v.profile) <= 20
      )
    ])
    error_message = "Each profile list must contain between 1 and 20 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.rule == null || (length(item.rule) <= 10))])
      )
    ])
    error_message = "Each rule list must contain at most 10 items"
  }
  # --- Unconfirmed validation candidates, derived from azurerm_monitor_autoscale_setting's provider source ---
  # Not auto-enabled: either a bespoke provider validator we can't safely translate,
  # or a path that crosses a list-typed block (needs its own for_each wrapping).
  # Review, translate into a real validation{} block above, and delete once confirmed.
  # path: name
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: resource_group_name
  #   condition: length(value) <= 90
  #   message:   [from resourcegroups.ValidateName: invalid when len(value) > 90]
  #   source:    [from resourcegroups.ValidateName: invalid when len(value) > 90]
  # path: resource_group_name
  #   condition: !endswith(value, ".")
  #   message:   [from resourcegroups.ValidateName: must not end with "."]
  #   source:    [from resourcegroups.ValidateName: must not end with "."]
  # path: resource_group_name
  #   condition: length(value) != 0
  #   message:   [from resourcegroups.ValidateName: invalid when len(value) == 0]
  #   source:    [from resourcegroups.ValidateName: invalid when len(value) == 0]
  # path: resource_group_name
  #   source:    [from resourcegroups.ValidateName] !matched
  # path: location
  #   source:    location.EnhancedValidate: no recognizable `if ... { errors = append(...) }` pattern - read it by hand
  # path: target_resource_id
  #   source:    [from azure.ValidateResourceID] !ok
  # path: target_resource_id
  #   source:    [from azure.ValidateResourceID] err != nil
  # path: predictive.scale_mode
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: predictive.look_ahead_time
  #   source:    validate.ISO8601DurationBetween: no recognizable `if ... { errors = append(...) }` pattern - read it by hand
  # path: profile.name
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: profile.capacity.minimum
  #   condition: value >= 0 && value <= 1000
  #   message:   must be between 0 and 1000
  # path: profile.capacity.maximum
  #   condition: value >= 0 && value <= 1000
  #   message:   must be between 0 and 1000
  # path: profile.capacity.default
  #   condition: value >= 0 && value <= 1000
  #   message:   must be between 0 and 1000
  # path: profile.rule.metric_trigger.metric_name
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: profile.rule.metric_trigger.metric_resource_id
  #   source:    [from azure.ValidateResourceID] !ok
  # path: profile.rule.metric_trigger.metric_resource_id
  #   source:    [from azure.ValidateResourceID] err != nil
  # path: profile.rule.metric_trigger.time_grain
  #   source:    [from validate.ISO8601Duration] !ok
  # path: profile.rule.metric_trigger.time_grain
  #   source:    [from validate.ISO8601Duration] err != nil
  # path: profile.rule.metric_trigger.statistic
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: profile.rule.metric_trigger.time_window
  #   source:    [from validate.ISO8601Duration] !ok
  # path: profile.rule.metric_trigger.time_window
  #   source:    [from validate.ISO8601Duration] err != nil
  # path: profile.rule.metric_trigger.time_aggregation
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: profile.rule.metric_trigger.operator
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: profile.rule.metric_trigger.metric_namespace
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: profile.rule.metric_trigger.dimensions.name
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: profile.rule.metric_trigger.dimensions.operator
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: profile.rule.metric_trigger.dimensions.values[*]
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: profile.rule.scale_action.direction
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: profile.rule.scale_action.type
  #   source:    validation.StringInSlice value list is not a literal []string - likely a generated PossibleValuesFor*() helper; resolve separately
  # path: profile.rule.scale_action.value
  #   condition: value >= 0
  #   message:   must be at least 0
  # path: profile.rule.scale_action.cooldown
  #   source:    [from validate.ISO8601Duration] !ok
  # path: profile.rule.scale_action.cooldown
  #   source:    [from validate.ISO8601Duration] err != nil
  # path: profile.fixed_date.timezone
  #   source:    validateAutoScaleSettingsTimeZone: no recognizable `if ... { errors = append(...) }` pattern - read it by hand
  # path: profile.fixed_date.start
  #   source:    validation.IsRFC3339Time(...) - no translation rule yet, add one
  # path: profile.fixed_date.end
  #   source:    validation.IsRFC3339Time(...) - no translation rule yet, add one
  # path: profile.recurrence.timezone
  #   source:    validateAutoScaleSettingsTimeZone: no recognizable `if ... { errors = append(...) }` pattern - read it by hand
  # path: profile.recurrence.days[*]
  #   condition: contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], value)
  #   message:   must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
  # path: profile.recurrence.hours[*]
  #   condition: value >= 0 && value <= 23
  #   message:   must be between 0 and 23
  # path: profile.recurrence.minutes[*]
  #   condition: value >= 0 && value <= 59
  #   message:   must be between 0 and 59
  # path: notification.email.custom_emails[*]
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: notification.webhook.service_uri
  #   condition: length(value) > 0
  #   message:   must not be empty
  # path: tags
  #   condition: length(value) <= 50
  #   message:   [from tags.Validate: invalid when len(value) > 50]
  #   source:    [from tags.Validate: invalid when len(value) > 50]
  # path: tags
  #   condition: length(value) <= 512
  #   message:   [from tags.Validate: invalid when len(value) > 512]
  #   source:    [from tags.Validate: invalid when len(value) > 512]
  # path: tags
  #   source:    [from tags.Validate] err != nil
  # path: tags
  #   condition: length(value) <= 256
  #   message:   [from tags.Validate: invalid when len(value) > 256]
  #   source:    [from tags.Validate: invalid when len(value) > 256]
}

