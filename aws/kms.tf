data "aws_iam_policy_document" "kms" {
  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_kms.html
    actions = [
      "kms:*",
    ]

    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${local.account_id}:root",
      ]
    }

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    // https://docs.aws.amazon.com/IAM/latest/UserGuide/list_kms.html
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    principals = {
      type = "Service"

      identifiers = [
        "logs.${var.region}.amazonaws.com",
      ]
    }

    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "geopoiesis" {
  description         = "Geopoiesis KMS key"
  enable_key_rotation = true
  policy              = "${data.aws_iam_policy_document.kms.json}"

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
