

variable "default_tags" {
  description = "(Optional) default Map of tags to apply to resources."
  type        = map(any)
}

variable "default_acm_admin_iam_arns" {
  description = "(Optional) List of IAM roles/users who have full access to manage all keys."
  type        = list(string)
  default     = []
}

variable "default_acm_user_iam_arms" {
  description = "(Optional) List of IAM roles/users who can decrypt / encrypt all keys."
  type        = list(string)
  default     = []
}

variable "default_acm_grant_iam_arns" {
  description = "(Optional) List of IAM roles/users who can grant use of all keys."
  type        = list(string)
  default     = []
}

variable "keys" {
  description = "Configuration for KMS Keys."
  default = {}
  type = map(object({
    description             = optional(string)
    name                    = string
    is_enabled              = optional(bool)
    key_usage               = optional(string)
    enable_key_rotation     = optional(bool)
    deletion_window_in_days = optional(number)
    tags                    = optional(map(any))
    policy_statements       = list(object({
      effect          = string
      actions         = optional(list(string))
      not_actions     = optional(list(string))
      resources       = optional(list(string))
      not_resources   = optional(list(string))
      principals      = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      not_principals  = optional(list(object({
        type        = string
        identifiers = list(string)
      })))
      conditions  = optional(list(object({
        test        = string
        variable    = string
        values      = list(string)
      })))
    }))
  }))  
}
