resource "tfe_variable_set" "default" {
  description       = var.description
  global            = var.global
  name              = var.name
  organization      = var.organization
  parent_project_id = var.parent_project_id
  priority          = var.priority
}

resource "tfe_project_variable_set" "default" {
  count = var.attach_to_project && var.parent_project_id != null ? 1 : 0

  project_id      = var.parent_project_id
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "default" {
  for_each = var.variables

  category        = each.value.category
  description     = each.value.description
  hcl             = each.value.hcl
  key             = each.key
  sensitive       = each.value.sensitive
  value           = each.value.value
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "write_only" {
  for_each = var.write_only_variables

  category         = each.value.category
  description      = each.value.description
  hcl              = each.value.hcl
  key              = each.key
  sensitive        = each.value.sensitive
  value_wo         = var.write_only_values[each.key]
  value_wo_version = each.value.value_wo_version
  variable_set_id  = tfe_variable_set.default.id
}