data "aws_caller_identity" "geopoiesis" {}

variable "lock_table_name" {
  default = "geopoiesis-lock"
}

variable "log_group_name" {
  default = "/geopoiesis"
}

variable "region" {
  default = "us-east-1"
}

variable "run_on_ecs" {
  default = true
}

variable "runs_table_name" {
  default = "geopoiesis-runs"
}

variable "s3_bucket" {
  default = "geopoiesis"
}

variable "ssm_prefix" {
  default = "geopoiesis"
}

variable "workers_table_name" {
  default = "geopoiesis-workers"
}

locals {
  account_id = "${data.aws_caller_identity.geopoiesis.account_id}"
}

// Static access key ID, generated when running Geopoiesis outside ECS.
output "access_key_id" {
  value = "${join("", aws_iam_access_key.geopoiesis.*.id)}"
}

// Static access key secret, generated when running Geopoiesis outside ECS.
output "secret_access_key" {
  value = "${join("", aws_iam_access_key.geopoiesis.*.secret)}"
}

// Policy ARN, used to attach to an arbitrary role or user.
output "policy_arn" {
  value = "${join("", aws_iam_policy.geopoiesis.*.arn)}"
}

// Role ARN, used to run Geopoiesis on ECS.
output "task_role_arn" {
  value = "${join("", aws_iam_role.geopoiesis.*.arn)}"
}
