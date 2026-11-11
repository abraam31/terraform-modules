# Bedrock Invocation Logging Terraform Module

This module enables Amazon Bedrock model invocation logging for the current account and region, delivering logs to both S3 and CloudWatch Logs.

It creates:

- A customer managed KMS key (with rotation) that encrypts both destinations
- A private, versioned S3 bucket with a lifecycle policy and a TLS-only bucket policy that lets Bedrock write logs
- A CloudWatch Logs log group with a fixed retention period
- An IAM role that Bedrock assumes to write to the log group, scoped with `aws:SourceAccount` and `aws:SourceArn`
- The `aws_bedrock_model_invocation_logging_configuration`, with payloads over 100 KB sent to the bucket under `large_data_key_prefix`

## Usage

```hcl
module "bedrock_invocation_logging" {
  source = "git@github.com:localytics/devops-terraform-modules.git//bedrock-invocation-logging?ref=master"

  bucket_name = "my-bedrock-invocation-logs"

  tags = {
    Environment = "prod"
  }
}
```

## Notes

- Invocation logging is a single setting per account and region. Applying this module replaces any configuration made in the console, and only one instance of it should exist per account and region.
- Logs are written in the region where the model is invoked. Deploy the module once per region that serves Bedrock traffic.
- Logs contain full prompts and responses. Restrict read access to the bucket, log group, and KMS key accordingly.

## Import existing configuration

```bash
terraform import 'module.bedrock_invocation_logging.aws_bedrock_model_invocation_logging_configuration.this' us-east-1
```

## Variables

See `variables.tf` for all configurable options.

## Outputs

See `outputs.tf` for output values.
