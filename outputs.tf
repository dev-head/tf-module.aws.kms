
output "apply_metadata" {
  description = "Output metadata regarding the apply."
  value = format("[%s]::[%s]::[%s]",
    data.aws_caller_identity.current.account_id,
    data.aws_caller_identity.current.arn,
    data.aws_caller_identity.current.user_id
  )
}

output  "key_attributes" {
  description = "Map of maps, indexed by they `var.keys` key, to ensure it's accessible."
  value = { 
    for key,v in var.keys : key => {
      arn       = aws_kms_key.default[key].arn
      key_id    = aws_kms_key.default[key].key_id
      alias_arn = aws_kms_alias.default[key].arn
    }    
  }
}

output  "key_resources" {
  description = "Provide full access to resource objects."
  value = {
    for key,v in var.keys : key => { key = aws_kms_key.default[key]}
  }
}
