provider "tfe" {}

# Ephemeral input variables are never stored in state or in the plan.
# Supply the value at runtime, e.g. with TF_VAR_api_token, or from an
# ephemeral resource such as a secrets manager lookup.
variable "api_token" {
  type        = string
  description = "API token that must not end up in the Terraform state."
  ephemeral   = true
  sensitive   = true
}

module "tfe_variable_set" {
  source = "../.."

  description = "credentials"
  name        = "credentials"

  # Regular variables: values are stored in state (use for non-secrets).
  variables = {
    "API_URL" = {
      value    = "https://api.example.com"
      category = "env"
    }
  }

  # Write-only variables: metadata is declared here...
  write_only_variables = {
    "API_TOKEN" = {
      category    = "env"
      description = "API token"
    }
  }

  # ...and the secret values are passed separately, as ephemeral values.
  write_only_values = {
    "API_TOKEN" = var.api_token
  }
}
