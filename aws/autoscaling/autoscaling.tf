variable "entity" {}

variable "type" {
  default = "table"
}

module "read" {
  source = "./common"

  entity = "${var.entity}"
  optype = "Read"
  type   = "${var.type}"
}

module "write" {
  source = "./common"

  optype = "Write"
  entity = "${var.entity}"
  type   = "${var.type}"
}
