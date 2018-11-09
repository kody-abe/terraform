data "aws_caller_identity" "geopoiesis" {}

variable "log_group_name" {
  default = "/geopoiesis"
}

variable "min_capacity" {
  default = 1
}

variable "policy_name" {
  default = "geopoiesis"
}

variable "region" {}

variable "runs_table_name" {
  default = "geopoiesis-runs"
}

variable "s3_bucket_prefix" {
  default = "geopoiesis"
}

variable "scopes_table_name" {
  default = "geopoiesis-scopes"
}

variable "ssm_prefix" {
  default = "/geopoiesis"
}

variable "workers_table_name" {
  default = "geopoiesis-workers"
}

locals {
  account_id = "${data.aws_caller_identity.geopoiesis.account_id}"
}

// KMS key ID for the backend to use.
output "kms_key_id" {
  value = "${aws_kms_key.geopoiesis.key_id}"
}

// Policy ARN, used to attach to an arbitrary role or user.
output "policy_arn" {
  value = "${aws_iam_policy.geopoiesis.arn}"
}

// S3 bucket name for the backend to use.
output "s3_bucket_name" {
  value = "${aws_s3_bucket.geopoiesis.id}"
}
