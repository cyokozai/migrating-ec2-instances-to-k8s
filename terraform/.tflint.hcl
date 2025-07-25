# TFLint configuration file
# This file configures TFLint to use the AWS ruleset and enables all Terraform checks and plugins.
# For more information, see https://github.com/terraform-linters/tflint

plugin "terraform" {
  enabled = true
  preset  = "all"
}

# TFLint AWS ruleset
plugin "aws" {
    enabled = true
    version = "0.40.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
