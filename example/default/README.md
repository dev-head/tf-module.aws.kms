Example :: KMS Key

=============
Description
-----------
This is just a basic example, ti represent a minimal configuration for KMS Key(s).


#### Change to required Terraform Version
```commandline
chtf 1.1.9
```

#### Make commands (includes local.ini support)
```commandline
make apply
make help
make plan
```

Example Outputs 
---------------
```
key_attributes = {
  "example_s3_01" = {
    "alias_arn" = "arn:aws:kms:us-west-2:55555555555:alias/example-default-s3-v01"
    "arn"       = "arn:aws:kms:us-west-2:55555555555:key/55555555555-aaaaa-55555-bbbbb-555555555"
    "key_id"    = "55555555555-aaaaa-55555-bbbbb-555555555"
  }
}
```