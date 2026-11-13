variable "attach_to_project" {
  type        = bool
  default     = true
  description = "Whether to attach the variable set to the parent project if 'parent_project_id' is set."
  nullable    = false
}

variable "description" {
  type        = string
  description = "Description of the variable set."
}

variable "global" {
  type        = bool
  default     = false
  description = "Whether the variable set applies to all workspaces in the organization."

  validation {
    condition     = !var.global || var.parent_project_id == null
    error_message = "If 'global' is set to true, then 'parent_project_id' must not be set."
  }
}

variable "name" {
  type        = string
  description = "Name of the variable set."
}

variable "organization" {
  type        = string
  default     = null
  description = "Name of the organization. If omitted, organization must be defined in the provider config."
}

variable "parent_project_id" {
  type        = string
  default     = null
  description = "ID of the project that should own the variable set. If set, then var.global must be false."
}

variable "priority" {
  type        = bool
  default     = false
  description = "Whether the variables in this set can be over-written by more specific scopes including values set on the command line."
}

variable "variables" {
  type = map(object({
    category    = string
    description = optional(string, null)
    hcl         = optional(bool, false)
    sensitive   = optional(bool, false)
    value       = string
  }))
  description = "Map of variables."
}

variable "write_only_values" {
  type        = map(string)
  default     = {}
  description = "Ephemeral values for the variables in 'write_only_variables'."
  ephemeral   = true
  nullable    = false
  sensitive   = true
}

variable "write_only_variables" {
  type = map(object({
    category         = string
    description      = optional(string, null)
    hcl              = optional(bool, false)
    sensitive        = optional(bool, true)
    value_wo_version = optional(number, null)
  }))
  default     = {}
  description = "Map of variables whose values are write-only."
  nullable    = false

  validation {
    condition     = length(setintersection(keys(var.variables), keys(var.write_only_variables))) == 0
    error_message = "A variable name can only be set in either 'variables' or 'write_only_variables', not both."
  }
}