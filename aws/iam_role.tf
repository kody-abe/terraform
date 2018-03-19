data "aws_iam_policy_document" "geopoiesis-assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "geopoiesis" {
  count = "${var.run_on_ecs ? 1 : 0}"

  name               = "geipoiesis"
  assume_role_policy = "${data.aws_iam_policy_document.geopoiesis-assume.json}"
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  count = "${var.run_on_ecs ? 1 : 0}"

  role       = "${join("", aws_iam_role.geopoiesis.*.name)}"
  policy_arn = "${aws_iam_policy.geopoiesis.arn}"
}
