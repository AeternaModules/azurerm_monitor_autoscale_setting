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
    enabled             = optional(bool, true)
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
        timezone = optional(string, "UTC")
      }))
      name = string
      recurrence = optional(object({
        days     = list(string)
        hours    = list(number)
        minutes  = list(number)
        timezone = optional(string, "UTC")
      }))
      rule = optional(list(object({
        metric_trigger = object({
          dimensions = optional(object({
            name     = string
            operator = string
            values   = list(string)
          }))
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
        send_to_subscription_administrator    = optional(bool, false)
        send_to_subscription_co_administrator = optional(bool, false)
      }))
      webhook = optional(object({
        properties  = optional(map(string))
        service_uri = string
      }))
    }))
    predictive = optional(object({
      look_ahead_time = optional(string)
      scale_mode      = string
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        length(v.profile) <= 20
      )
    ])
    error_message = "Each profile list must contain at most 20 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.monitor_autoscale_settings : (
        v.profile == null || alltrue([for item in v.profile : (item.rule == null || (length(item.rule) <= 10))])
      )
    ])
    error_message = "Each rule list must contain at most 10 items"
  }
}

