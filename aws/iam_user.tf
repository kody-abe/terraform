resource "aws_iam_user" "geopoiesis" {
  count = "${var.run_on_ecs ? 0 : 1}"

  name = "geopoiesis"
}

resource "aws_iam_user_policy_attachment" "geopoiesis" {
  count = "${var.run_on_ecs ? 0 : 1}"

  user       = "${join("", aws_iam_user.geopoiesis.*.name)}"
  policy_arn = "${aws_iam_policy.geopoiesis.arn}"
}

resource "aws_iam_access_key" "geopoiesis" {
  count = "${var.run_on_ecs ? 0 : 1}"

  user = "${join("", aws_iam_user.geopoiesis.*.name)}"
}
