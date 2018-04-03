// TODO: add autoscaling to read and write capacity.
// Use target tracking with DynamoDBReadCapacityUtilization and
// DynamoDBWriteCapacityUtilization set to something like 70%.

resource "aws_dynamodb_table" "geopoiesis-lock" {
  name           = "${var.lock_table_name}"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "scope"

  attribute {
    name = "scope"
    type = "S"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}

resource "aws_dynamodb_table" "geopoiesis-runs" {
  name           = "${var.runs_table_name}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "scope"
  range_key      = "id"

  attribute {
    name = "scope"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "scope_with_state"
    type = "S"
  }

  attribute {
    name = "scope_with_blocking"
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
    hash_key        = "scope_with_state"
    range_key       = "id"
    name            = "bystate"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }

  global_secondary_index {
    hash_key           = "scope_with_blocking"
    range_key          = "id"
    name               = "byblocking"
    projection_type    = "INCLUDE"
    non_key_attributes = ["state", "worker_id"]
    read_capacity      = 3
    write_capacity     = 3
  }

  global_secondary_index {
    hash_key        = "scope_with_type"
    range_key       = "id"
    name            = "bytype"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }

  global_secondary_index {
    hash_key        = "scope_with_visibility"
    range_key       = "id"
    name            = "byvisibility"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }

  global_secondary_index {
    hash_key        = "scope_with_worker_assigned"
    range_key       = "id"
    name            = "byworkerassigned"
    projection_type = "ALL"
    read_capacity   = 3
    write_capacity  = 3
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}

resource "aws_dynamodb_table" "geopoiesis-workers" {
  name           = "${var.workers_table_name}"
  read_capacity  = 3
  write_capacity = 2
  hash_key       = "worker_id"

  attribute {
    name = "worker_id"
    type = "S"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}
