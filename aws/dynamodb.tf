resource "aws_dynamodb_table" "geopoiesis-scopes" {
  name           = "${var.scopes_table_name}"
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

module "geopoiesis-scopes-autoscaling" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-scopes.name}"
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
    read_capacity   = "${var.min_capacity}"
    write_capacity  = "${var.min_capacity}"
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

module "geopoiesis-runs-autoscaling-byqueued" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/byqueued"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

module "geopoiesis-runs-autoscaling-bytype" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/bytype"
  min_capacity = "${var.min_capacity}"
  type         = "index"
}

module "geopoiesis-runs-autoscaling-byvisibility" {
  source = "./autoscaling"

  entity       = "${aws_dynamodb_table.geopoiesis-runs.name}/index/byvisibility"
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
