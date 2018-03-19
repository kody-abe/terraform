resource "aws_cloudwatch_log_group" "geopoiesis" {
  name       = "${var.log_group_name}"
  kms_key_id = "${aws_kms_key.geopoiesis.arn}"

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
