// TODO: add autoscaling to read and write capacity.
// Use target tracking with DynamoDBReadCapacityUtilization and
// DynamoDBWriteCapacityUtilization set to something like 70%.

resource "aws_dynamodb_table" "geopoiesis-lock" {
  name           = "${var.lock_table_name}"
  read_capacity  = "${var.min_capacity}"
  write_capacity = "${var.min_capacity}"
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

module "geopoiesis-lock-autoscaling" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-lock.name}"
  min_capacity = "${var.min_capacity}"
}

resource "aws_dynamodb_table" "geopoiesis-runs" {
  name           = "${var.runs_table_name}"
  read_capacity  = "${var.min_capacity}"
  write_capacity = "${var.min_capacity}"
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
    read_capacity   = "${var.min_capacity}"
    write_capacity  = "${var.min_capacity}"
  }

  global_secondary_index {
    hash_key           = "scope_with_blocking"
    range_key          = "id"
    name               = "byblocking"
    projection_type    = "INCLUDE"
    non_key_attributes = ["state", "worker_id"]
    read_capacity      = "${var.min_capacity}"
    write_capacity     = "${var.min_capacity}"
  }

  global_secondary_index {
    hash_key        = "scope_with_type"
    range_key       = "id"
    name            = "bytype"
    projection_type = "ALL"
    read_capacity   = "${var.min_capacity}"
    write_capacity  = "${var.min_capacity}"
  }

  global_secondary_index {
    hash_key        = "scope_with_visibility"
    range_key       = "id"
    name            = "byvisibility"
    projection_type = "ALL"
    read_capacity   = "${var.min_capacity}"
    write_capacity  = "${var.min_capacity}"
  }

  global_secondary_index {
    hash_key        = "scope_with_worker_assigned"
    range_key       = "id"
    name            = "byworkerassigned"
    projection_type = "ALL"
    read_capacity   = "${var.min_capacity}"
    write_capacity  = "${var.min_capacity}"
  }

  lifecycle {
    ignore_changes = [
      "global_secondary_index",
      "read_capacity",
      "write_capacity",
    ]
  }

  tags {
    Name        = "Owner"
    Description = "Geopoiesis"
  }
}

module "geopoiesis-runs-autoscaling" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}"
  min_capacity = "${var.min_capacity}"
}

module "geopoiesis-runs-autoscaling-byblocking" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/byblocking"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

module "geopoiesis-runs-autoscaling-byvisibility" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/byvisibility"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

module "geopoiesis-runs-autoscaling-bytype" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/bytype"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

module "geopoiesis-runs-autoscaling-bystate" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/bystate"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

module "geopoiesis-runs-autoscaling-byworkerassigned" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/byworkerassigned"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

resource "aws_dynamodb_table" "geopoiesis-workers" {
  name           = "${var.workers_table_name}"
  read_capacity  = "${var.min_capacity}"
  write_capacity = "${var.min_capacity}"
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

module "geopoiesis-workers-autoscaling" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-workers.name}"
  min_capacity = "${var.min_capacity}"
}
