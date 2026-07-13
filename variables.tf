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
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        length(v.name) > 0
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        length(v.resource_group_name) <= 90
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) > 90]"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        !endswith(v.resource_group_name, ".")
      )
    ])
    error_message = "[from resourcegroups.ValidateName: must not end with \".\"]"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        length(v.resource_group_name) != 0
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) == 0]"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (length(item.name) > 0)])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.capacity.minimum >= 0 && item.capacity.minimum <= 1000)])
      )
    ])
    error_message = "must be between 0 and 1000"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.capacity.maximum >= 0 && item.capacity.maximum <= 1000)])
      )
    ])
    error_message = "must be between 0 and 1000"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.capacity.default >= 0 && item.capacity.default <= 1000)])
      )
    ])
    error_message = "must be between 0 and 1000"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.rule == null || alltrue([for item in item.rule : (length(item.metric_trigger.metric_name) > 0)]))])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.rule == null || alltrue([for item in item.rule : (item.metric_trigger.metric_namespace == null || (length(item.metric_trigger.metric_namespace) > 0))]))])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.rule == null || alltrue([for item in item.rule : (item.metric_trigger.dimensions == null || alltrue([for item in item.metric_trigger.dimensions : (length(item.name) > 0)]))]))])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.rule == null || alltrue([for item in item.rule : (item.metric_trigger.dimensions == null || alltrue([for item in item.metric_trigger.dimensions : (alltrue([for x in item.values : length(x) > 0]))]))]))])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.rule == null || alltrue([for item in item.rule : (item.scale_action.value >= 0)]))])
      )
    ])
    error_message = "must be at least 0"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.recurrence == null || (alltrue([for x in item.recurrence.days : contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], x)])))])
      )
    ])
    error_message = "must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.recurrence == null || (alltrue([for x in item.recurrence.hours : x >= 0 && x <= 23])))])
      )
    ])
    error_message = "must be between 0 and 23"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        alltrue([for item in v.profile : (item.recurrence == null || (alltrue([for x in item.recurrence.minutes : x >= 0 && x <= 59])))])
      )
    ])
    error_message = "must be between 0 and 59"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        v.notification == null || (v.notification.email == null || (v.notification.email.custom_emails == null || (alltrue([for x in v.notification.email.custom_emails : length(x) > 0]))))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        v.notification == null || (v.notification.webhook == null || alltrue([for item in v.notification.webhook : (length(item.service_uri) > 0)]))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        v.tags == null || (length(v.tags) <= 50)
      )
    ])
    error_message = "[from tags.Validate: invalid when len(value) > 50]"
  }
  # Note: 27 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

