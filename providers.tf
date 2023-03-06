terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
  
  experiments = [module_variable_optional_attrs]  
}