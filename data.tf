data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {

  # we need to remove null objects to support conditional iam policies.
  default_policies = [for item in local.default_policies_list: item if item != null]
    
  default_policies_list  = [
      (data.aws_caller_identity.current.account_id != ""? {
        sid             = "Enable IAM User Permissions"
        effect          = "Allow"
        actions         = ["kms:*"]
        resources       = ["*"]
        conditions      = []
        not_principals  = []
        principals = [{
          type = "AWS"
          identifiers = [format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)]
        }]
      } : null),


      (length(var.default_acm_admin_iam_arns) > 0? {
        sid     = "Allow access for Key Administrators"
        effect  = "Allow"
        actions = [
          "kms:Update*",
          "kms:UntagResource",
          "kms:TagResource",
          "kms:ScheduleKeyDeletion",
          "kms:Revoke*",
          "kms:Put*",
          "kms:List*",
          "kms:Get*",
          "kms:Enable*",
          "kms:Disable*",
          "kms:Describe*",
          "kms:Delete*",
          "kms:Create*",
          "kms:CancelKeyDeletion"        
        ]
        resources       = ["*"]
        conditions      = []
        not_principals  = []
        principals      = [{type = "AWS", identifiers = var.default_acm_admin_iam_arns}]
      } : null),


      (length(var.default_acm_user_iam_arms) > 0? {
        sid     = "Allow use of the key"
        effect  = "Allow"
        actions = [
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt"     
        ]
        resources       = ["*"]
        conditions      = []
        not_principals  = []
        principals      = [{type = "AWS", identifiers = var.default_acm_user_iam_arms}]
      } : null),

      (length(var.default_acm_grant_iam_arns) > 0? {
        sid     = "Allow attachment of persistent resources"
        effect  = "Allow"
        actions = [
          "kms:RevokeGrant",
          "kms:ListGrants",
          "kms:CreateGrant"    
        ]
        resources       = ["*"]
        conditions      = [{test = "Bool", variable = "kms:GrantIsForAWSResource", values = ["true"]}]
        not_principals  = []
        principals      = [{type = "AWS", identifiers = var.default_acm_grant_iam_arns}]
      } : null)  
  ]  
}

data "aws_iam_policy_document" "default" {
  for_each = var.keys
  
  dynamic "statement" {
    for_each = concat(local.default_policies, each.value["policy_statements"])

    content {
      sid           = lookup(statement.value, "sid", null)
      actions       = lookup(statement.value, "actions", null)
      not_actions   = lookup(statement.value, "not_actions", null)
      effect        = lookup(statement.value, "effect", null)
      resources     = lookup(statement.value, "resources", null)
      not_resources = lookup(statement.value, "not_resources", null)

      dynamic "condition" {
        for_each = statement.value["conditions"] == null? [] : statement.value["conditions"]
        
        content {
          test      = lookup(condition.value, "test", null)
          variable  = lookup(condition.value, "variable", null)
          values    = lookup(condition.value, "values", null)
        }
      }

      dynamic "principals" {
        for_each = statement.value["principals"] == null? [] : statement.value["principals"]
        content {
          type        = lookup(principals.value, "type", null)
          identifiers = lookup(principals.value, "identifiers", null)
        }
      }

      dynamic "not_principals" {
        for_each = statement.value["not_principals"] == null? [] : statement.value["not_principals"]
        content {
          type        = lookup(not_principals.value, "type", null)
          identifiers = lookup(not_principals.value, "identifiers", null)
        }
      }
    }
  }
}