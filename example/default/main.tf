#------------------------------------------------------------------------------#
# @title: Terraform Example
# @description: Used to test and provide a working example for this module.
#------------------------------------------------------------------------------#

terraform {
  required_version = "~> 1.1.9"
  experiments = [module_variable_optional_attrs]  
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

variable "aws_region" {
  description = "(Optional) AWS region for this to be applied to. (Default: 'us-east-1')"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "(Optional) Provider AWS profile name for local aws cli configuration. (Default: '')"
  type        = string
  default     = ""
}

module "example" {
  source = "../../"
  
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

output "key_attributes" {
  description = "Map of maps, indexed by they `var.keys` key, to ensure it's accessable."
  value       = module.example.key_attributes
}

