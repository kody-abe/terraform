variable "entity" {}

variable "min_capacity" {}

variable "type" {
  default = "table"
}

module "read" {
  source = "./common"

  entity       = "${var.entity}"
  min_capacity = "${var.min_capacity}"
  optype       = "Read"
  type         = "${var.type}"
}

module "write" {
  source = "./common"

  entity       = "${var.entity}"
  min_capacity = "${var.min_capacity}"
  optype       = "Write"
  type         = "${var.type}"
}
