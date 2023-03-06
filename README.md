Terraform AWS :: KMS Module
===========================

Description
-----------
Terraform AWS S3 Module for configuration of one or more KMS Customer managed encryption keys. 

Example
-------
> [Example Module](./example/default) found in `./example/default`
* [Terraform Docs on S3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)


Inputs 
-------
| key                         | type          | Description 
|:---------------------------:|:-------------:| ------------------------------------------------------------------------------------:| 
| default_tags                | map(any)      | (Optional) default Map of tags to apply to resources.
| default_acm_admin_iam_arns  | list(string)  | (Optional) List of IAM roles/users who have full access to manage all keys.
| default_acm_user_iam_arms   | list(string)  | (Optional) List of IAM roles/users who can decrypt / encrypt all keys.
| default_acm_grant_iam_arns  | list(string)  | (Optional) List of IAM roles/users who can grant use of all keys.
| keys                        | map(object()) | Define one or more kms key configurations (see `variables.tf` for full definition).


Usage :: Defined Variables
--------------------------- 
```hcl-terraform

module "kms" {
  source = "git@github.com:dev-head/tf-module.aws.kms.git?ref=0.0.1"

  # Optionally provide default role arns as needed.
  default_acm_admin_iam_arns  = []
  default_acm_user_iam_arms   = []
  default_acm_grant_iam_arns  = []

  default_tags = {
    ManagedBy = "terraform"
  }
  
  keys = {
    example_s3_01 = {
      name              = "example-default-s3-v01"
      description       = "Key used for [default]::[S3]::[v01]::Encryption."
      tags              = {Environment = "TerraformTesting"}
      policy_statements = [
        {
          sid             = "AllowServiceAccess"
          effect          = "Allow"
          principals      = [{type = "Service", identifiers = ["s3.amazonaws.com"]}]
          actions         = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey*"]
          resources       = ["arn:aws:s3:::example*"]
        }
      ]
    }
  }
}
```

Outputs 
-------
| key               | type      | Description 
|:-----------------:|:---------:| ------------------------------------------------------------------------------------:| 
| apply_metadata    | string    | Output metadata regarding the apply.
| key_attributes    | object    | Map of maps, indexed by they `var.keys` key, to ensure it's accessible.
| key_resources     | object    | Provide full access to resource objects.

#### Example 
```
key_attributes = {
  "example_s3_01" = {
    "alias_arn" = "arn:aws:kms:us-west-2:55555555555:alias/example-default-s3-v01"
    "arn"       = "arn:aws:kms:us-west-2:55555555555:key/55555555555-aaaaa-55555-bbbbb-555555555"
    "key_id"    = "55555555555-aaaaa-55555-bbbbb-555555555"
  }
}
```
