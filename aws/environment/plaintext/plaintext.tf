// Name of the plaintext environment variable.
variable "name" {}

// Scope to which the environment variable belongs.
variable "scope" {}

// Path prefix for Geopoiesis SSM variables.
variable "ssm_prefix" {
  default = "/geopoiesis"
}

// Value of the plaintext environment variable.
variable "value" {}

resource "aws_ssm_parameter" "plaintext" {
  name  = "/${var.ssm_prefix}/${var.scope}/${var.name}"
  value = "${var.value}"

  type = "String"

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
