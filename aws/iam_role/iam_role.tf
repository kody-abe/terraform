// IAM role-based authentication, useful to run Geopoiesis on AWS
// (ECS, Beanstalk etc).

variable "aws_service" {
  default = "ecs-tasks.amazonaws.com"
}

variable "policy_arn" {}

data "aws_iam_policy_document" "geopoiesis-assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["${var.aws_service}"]
    }
  }
}

resource "aws_iam_role" "geopoiesis" {
  name               = "geipoiesis"
  assume_role_policy = "${data.aws_iam_policy_document.geopoiesis-assume.json}"
}

resource "aws_iam_role_policy_attachment" "geopoiesis" {
  role       = "${aws_iam_role.geopoiesis.name}"
  policy_arn = "${var.policy_arn}"
}

output "role_arn" {
  value = "${aws_iam_role.geopoiesis.arn}"
}
