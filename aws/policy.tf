data "aws_iam_policy_document" "geopoiesis" {
  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_logs.html
    actions = [
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.geopoiesis.arn}",
      "${aws_cloudwatch_log_group.geopoiesis.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_dynamodb.html
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
    ]

    resources = [
      "${aws_dynamodb_table.geopoiesis-lock.arn}",
      "${aws_dynamodb_table.geopoiesis-lock.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_dynamodb.html
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
    ]

    resources = [
      "${aws_dynamodb_table.geopoiesis-runs.arn}",
      "${aws_dynamodb_table.geopoiesis-runs.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_dynamodb.html
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]

    resources = [
      "${aws_dynamodb_table.geopoiesis-workers.arn}",
      "${aws_dynamodb_table.geopoiesis-workers.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_kms.html
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]

    resources = [
      "${aws_kms_key.geopoiesis.arn}",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_s3.html
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.geopoiesis.arn}",
      "${aws_s3_bucket.geopoiesis.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_ssm.html
    actions = [
      "ssm:DeleteParameter",
      "ssm:GetParameter",
      "ssm:PutParameter",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/${var.ssm_prefix}/*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_ssm.html
    actions = [
      "ssm:GetParametersByPath",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "geopoiesis" {
  name        = "geopoiesis"
  description = "Minimal access permissions for the Geopoiesis AWS backend"
  policy      = "${data.aws_iam_policy_document.geopoiesis.json}"
}
