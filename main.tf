
locals {
    role_name = join("-", [var.project_name,var.module_name,var.env])
    role_policy_name = join("-", [var.project_name,var.module_name,"policy",var.env])
}


resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.role_assumer.json
  description          = var.description
  permissions_boundary = var.permission_boundary
  tags                 = var.resource_tags
}


resource "aws_iam_role_policy" "this" {
  name      = local.role_policy_name
  role      = aws_iam_role.this.id
  policy    = data.aws_iam_policy_document.role_policy.json
}


data "aws_iam_policy_document" "role_assumer" {
  statement {
    actions = var.role_assumer_actions

    principals {
      type        = var.role_assumer_type
      identifiers = [lookup(var.default_identifiers,var.service_to_assume_role,var.service_to_assume_role)]
    }
  }
}


data "aws_iam_policy_document" "role_policy" {

  dynamic "statement" {
    for_each = var.policy_statements
      content {
        sid         = try(statement.value["sid"],"")
        effect      = try(statement.value["effect"],"Allow")
        actions     = statement.value["actions"]
        resources   = statement.value["resources"]
        
         
        dynamic "condition" {
          for_each = try(length(statement.value["condition_test"]) > 0,false) ? [1] : []
            content {
              test     = statement.value["condition_test"]
              variable = statement.value["condition_variable"]
              values = statement.value["condition_values"]
            }
        }
    }
  }
}
