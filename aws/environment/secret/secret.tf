// ID of the KMS key used to encrypt the value at rest.
variable "kms_key_id" {}

// Name of the secret environment variable.
variable "name" {}

// Scope to which the environment variable belongs.
variable "scope" {}

// Path prefix for Geopoiesis SSM variables.
variable "ssm_prefix" {
  default = "/geopoiesis"
}

// Value of the secret environment variable.
variable "value" {}

resource "aws_ssm_parameter" "secret" {
  name  = "${var.ssm_prefix}/${var.scope}/${var.name}"
  value = "${var.value}"

  type   = "SecureString"
  key_id = "${var.kms_key_id}"

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
