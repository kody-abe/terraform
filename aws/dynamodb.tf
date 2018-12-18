resource "aws_dynamodb_table" "geopoiesis-scopes" {
  name     = "${var.scopes_table_name}"
  hash_key = "scope"

  attribute {
    name = "scope"
    type = "S"
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}

resource "aws_dynamodb_table" "geopoiesis-runs" {
  name         = "${var.runs_table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "scope"
  range_key    = "id"

  attribute {
    name = "scope"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "queued"
    type = "S"
  }

  attribute {
    name = "scope_with_type"
    type = "S"
  }

  attribute {
    name = "scope_with_visibility"
    type = "S"
  }

  attribute {
    name = "scope_with_worker_assigned"
    type = "S"
  }

  global_secondary_index {
    hash_key        = "queued"
    range_key       = "id"
    name            = "byqueued"
    projection_type = "ALL"
  }

  global_secondary_index {
    hash_key        = "scope_with_type"
    range_key       = "id"
    name            = "bytype"
    projection_type = "ALL"
  }

  global_secondary_index {
    hash_key        = "scope_with_visibility"
    range_key       = "id"
    name            = "byvisibility"
    projection_type = "ALL"
  }

  global_secondary_index {
    hash_key        = "scope_with_worker_assigned"
    range_key       = "id"
    name            = "byworkerassigned"
    projection_type = "ALL"
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}

resource "aws_dynamodb_table" "geopoiesis-workers" {
  name         = "${var.workers_table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "worker_id"

  attribute {
    name = "worker_id"
    type = "S"
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
