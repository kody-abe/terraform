// Note: bucket names need to be globally unique, so we're adding some randomness.
resource "random_string" "geopoiesis" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "geopoiesis" {
  acl           = "private"
  bucket        = "${var.s3_bucket_prefix}-${random_string.geopoiesis.result}"
  force_destroy = true
  region        = "${var.region}"

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
