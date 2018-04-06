resource "aws_appautoscaling_target" "target" {
  min_capacity       = 1
  max_capacity       = 100
  resource_id        = "table/${var.entity}"
  scalable_dimension = "dynamodb:${var.type}:${var.optype}CapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "target" {
  name               = "DynamoDB${var.optype}CapacityUtilization:${aws_appautoscaling_target.target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDB${var.optype}CapacityUtilization"
    }

    target_value = 70
  }
}
