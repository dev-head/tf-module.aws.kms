
resource "aws_kms_key" "default" {
  for_each                = var.keys
  description             = each.value["description"] == null? null : lookup(each.value, "description")  
  deletion_window_in_days = each.value["deletion_window_in_days"] == null? 30 : lookup(each.value, "deletion_window_in_days")
  key_usage               = each.value["key_usage"] == null? "ENCRYPT_DECRYPT" : lookup(each.value, "key_usage")
  is_enabled              = each.value["is_enabled"] == null? true : lookup(each.value, "is_enabled")
  enable_key_rotation     = each.value["enable_key_rotation"] == null? true : lookup(each.value, "enable_key_rotation")
  tags                    = each.value["tags"] == null? merge(
    {"Name": (each.value["name"] == null? each.key : each.value["name"])}, 
    var.default_tags
  ) : merge(
    {"Name": (each.value["name"] == null? each.key : each.value["name"])}, 
    each.value["tags"], 
    var.default_tags
  )

  policy = data.aws_iam_policy_document.default[each.key].json
}

resource "aws_kms_alias" "default" {
  for_each      = var.keys
  name          = format("alias/%s", each.value["name"] == null? each.key : each.value["name"])
  target_key_id = aws_kms_key.default[each.key].key_id
}