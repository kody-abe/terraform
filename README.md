# Geopoiesis Terraform setup

This repository hosts Terraform templates to bootstrap a Geopoiesis installation.
For the time being, only AWS backend is supported.

## Core module (`/aws`)

The main module is located under `/aws` and it creates the following resources:

- an S3 bucket, used to temporarily store Terraform plans and workspaces pending
  user review;
- a CloudWatch Logs log group to persist logs from individual runs;
- three DynamoDB tables with associated secondary indexes;
- DynamoDB autoscaling rules, targeting 70% utilization of
  reads and writes;
- a KMS key used to secure application secrets and S3 objectss;
- an IAM policy giving the minimum necessary access to the above resources;

The minimal, default AWS backend setup looks very simple:

```hcl
module "geopoiesis-backend" {
  source = "github.com/geopoiesis/terraform//aws?ref=0.6.0"

  region = "us-east-1"
}
```

The full API is a bit more complex - see below.

### Inputs

- `log_group_name` (optional, default = `"/geopoiesis"`) - name of the CloudWatch
  Logs log group where logs for individuals runs are stored. Note that this is
  _not_ a destination for application logs. The only reason why you may want to
  use a non-standard name is running multiple installations of Geopoiesis in one
  AWS account;

- `min_capacity` (optional, default = `1`) - minimum provisioned read and write
  throughput for application DynamoDB tables. All Geopoiesis tables and indexes
  are autoscaled with 70% target utilization, but autoscaling takes a while to
  kick in, so if you are expecting heavier load, it's better to specify a lower
  bound that is larger than 1;

- `region` (required) - AWS region where resources are to be created. Remember
  it's a good practice to keep your storage and compute as close as possible;

- `runs_table_name` (optional, `default = "geopoiesis-runs"`) - name of the
  DynamoDB table used to store Runs history. The only reason why you may want to
  use a non-standard name is running multiple installations of Geopoiesis in one
  account;

- `s3_bucket_prefix` (optional, `default = "geopoiesis"`) - prefix for the name
  of the S3 bucket used to temporarily store Terraform plans and workspaces.
  Since S3 bucket names have to be globally unique per region, the final name is
  a combination of this prefix and a 16-digit random string. Hence, there should
  be no need to ever overwrite this setting;

- `scopes_table_name` (optional, `default = "geopoiesis-scopes"`) - name of the
  DynamoDB table used to store Scopes metadata. The only reason why you may want
  to use a non-standard name is running multiple installations of Geopoiesis in
  one account;

- `ssm_prefix` (optional, `default = "/geopoiesis"`) - SSM Parameter Store prefix
  for scope environment variables. While the core module does not create any SSM
  parameters, the prefix is required to grant Geopoiesis scope to manage
  lifecycle of future parameters under this prefix. The only reason why you may
  want to use a non-standard name is running multiple installations of Geopoiesis
  in one account;

- `workers_table_name` (optional, `default = "geopoiesis-workers"`) - name of the
  DynamoDB table used to store workers metadata. The only reason why you may want
  to use a non-standard name is running multiple installations of Geopoiesis in
  one account;

### Outputs

- `kms_key_id` - ID of the KMS key the backend will use for encryption purposes.
  You will need to pass this as an environment variable to your Geopoiesis
  installation;

- `policy_arn` - full ARN of the IAM policy, giving the minimum necessary access
  to the resources created by the module. Note that the policy itself doesn't do
  anything until it's to attached to an IAM role or user. Since in the core module
  does not want to force you into using one or the other, `iam_role` and `iam_user`
  modules are provided. Please consult their documentation for details.

- `s3_bucket_name` - full name of the S3 bucket used to temporarily store
  Terraform plans and workspaces. You will need to pass this as an environment
  variable to your Geopoiesis installation;

## AWS IAM role (`/aws/iam_role`)

This module creates an IAM role with the minimum set of permissions necessary to
operate Geopoiesis backend. When running Geopoiesis inside AWS, it is always
preferable to use role credentials, which are considered [safer](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html).

Usage example:

```hcl
module "geopoiesis-backend" {
  source = "github.com/geopoiesis/terraform//aws?ref=0.6.0"

  region = "us-east-1"
}

module "geopoiesis-role" {
  source = "github.com/geopoiesis/terraform//aws/iam_role?ref=0.6.0"

  policy_arn = "${module.geopoiesis-backend.policy_arn}"
}
```

### Inputs

- `aws_service` (optional, `default = "ecs-tasks.amazonaws.com"`) - AWS service
  which will grant the role to its user. By default we're assuming that
  Geopoiesis will be run using ECS, which recently introduced [Fargate](https://aws.amazon.com/fargate/)
  abstraction that allows you to run containers without having to manage
  servers. For vanilla EC2, the value should be [`ec2.amazonaws.com`](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html),
  and for EKS - [`eks.amazonaws.com`](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html);

- `policy_arn` - full ARN of the IAM policy generated by the core module;

### Outputs

- `role_arn` - full ARN of the IAM role. If you are running Geopoiesis directly
  on EC2, you will want to set it as your [instance role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).
  If you're using the ECS abstraction to run Geopoiesis in a container (which is
  what we advise), you will want to set it as your [task role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html)
  instead. In EKS, it should be set as [service role](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html);

## AWS IAM user (`/aws/iam_user`)

This module creates an IAM user with the minimum set of permissions necessary to
operate Geopoiesis backend. It exports static credentials (key ID and secret),
which can be used even outside the AWS environment - for example, for local
development.

The usage is quite simple:

```hcl
module "geopoiesis-backend" {
  source = "github.com/geopoiesis/terraform//aws?ref=0.6.0"

  region = "us-east-1"
}

module "geopoiesis-user" {
  source = "github.com/geopoiesis/terraform//aws/iam_user?ref=0.6.0"

  policy_arn = "${module.geopoiesis-backend.policy_arn}"
}
```

### Inputs

- `policy_arn` - full ARN of the IAM policy generated by the core module;

### Outputs

- `access_key_id` - IAM user access key ID. You will want to pass it to the
  Geopoiesis environment as `AWS_ACCESS_KEY_ID` variable;

- `access_key_secret` - IAM user access key secret. You will want to pass it to
  the Geopoiesis environment as `AWS_SECRET_ACCESS_KEY` variable;

## Scope environment variables (`/aws/environment`)

Geopoiesis scope-specific environment variables can be set through Geopoiesis
UI or API, but sometimes it may be more convenient to avoid copy pasta and set
them directly from Terraform. Since behind the scenes they're just SSM Parameter
Store entries, we can use the same mechanism declaratively.

There two separate templates available - one for plaintext variables and one for
encrypted ('secret') ones.

### Plaintext variable (`/aws/environment/plaintext`)

Plaintext variables can be freely accessed from Geopoiesis GUI and API. Here is
how to set one up using Terraform:

```hcl
module "production-aws-key-id" {
  source = "github.com/geopoiesis/terraform//aws/environment/plaintext?ref=0.6.0"

  name  = "AWS_ACCESS_KEY_ID"
  scope = "production"
  value = "${module.access.production_key_id}" # defined somewhere else
}
```

#### Inputs

- `name` (required) - name of the variable;

- `scope` (required) - Geopoiesis scope to which the variable belongs;

- `ssm_prefix` (optional, `default = "/geopoiesis"`) - path prefix for Geopoiesis
  SSM variables. Note that it must be consistent with the `ssm_prefix` input to
  the core module;

- `value` (required) - value of the variable;

### Encrypted ('secret') variable (`/aws/environment/secret`)

Secrets are passed to Terraform runs as environment variables, but they cannot
be freely accessed from Geopoiesis GUI and API, therefore making them somewhat
safer. Here is how to set one up using Terraform:

```hcl
module "geopoiesis-backend" {
  source = "github.com/geopoiesis/terraform//aws?ref=0.6.0"

  region = "us-east-1"
}

module "production-aws-secret-key" {
  source = "github.com/geopoiesis/terraform//aws/environment/secret?ref=0.6.0"

  kms_key_id = "${module.geopoiesis-backend.kms_key_id}"
  name       = "AWS_SECRET_ACCESS_KEY"
  scope      = "production"
  value      = "${module.access.production_key_secret}" # defined somewhere else
}
```

#### Inputs

- `kms_key_id` (required) - ID of the KMS key used to encrypt the value at rest.
  It should be obtained by referring to the `kms_key_id` output of the core
  module (see the example above);

- `name` (required) - name of the variable;

- `scope` (required) - Geopoiesis scope to which the variable belongs;

- `ssm_prefix` (optional, `default = "/geopoiesis"`) - path prefix for Geopoiesis
  SSM variables. Note that it must be consistent with the `ssm_prefix` input to
  the core module;

- `value` (required) - value of the variable;
