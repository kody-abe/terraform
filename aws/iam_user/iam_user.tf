// Static user credentials, useful when running Geopoiesis outside of AWS
// environment.
variable "policy_arn" {}

resource "aws_iam_user" "geopoiesis" {
  name = "geopoiesis"
}

resource "aws_iam_user_policy_attachment" "geopoiesis" {
  user       = "${aws_iam_user.geopoiesis.name}"
  policy_arn = "${var.policy_arn}"
}

resource "aws_iam_access_key" "geopoiesis" {
  user = "${aws_iam_user.geopoiesis.name}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.geopoiesis.id}"
}

output "access_key_secret" {
  value = "${aws_iam_access_key.geopoiesis.secret}"
}
