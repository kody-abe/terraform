data "aws_iam_policy_document" "geopoiesis" {
  # http://docs.aws.amazon.com/IAM/latest/UserGuide/list_cloudwatch.html
  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
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
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
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

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_logs.html
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
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
      "ssm:GetParametersByPath",
      "ssm:PutParameter",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/${var.ssm_prefix}/*",
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/${var.ssm_prefix}/*/*",
    ]
  }

  # https://docs.aws.amazon.com/IAM/latest/UserGuide/list_xray.html
  statement {
    actions = [
      "xray:PutTelemetryRecords",
      "xray:PutTraceSegments",
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
