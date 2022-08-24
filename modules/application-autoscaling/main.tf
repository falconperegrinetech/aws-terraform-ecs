resource "aws_appautoscaling_target" "this" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# resource "aws_appautoscaling_policy" "memory" {
#   name               = "${var.prefix}-${terraform.workspace}-memory"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.this.resource_id
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value = 80
#   }
# }

# resource "aws_appautoscaling_policy" "cpu" {
#   name               = "${var.prefix}-${terraform.workspace}-cpu"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.this.resource_id
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = 60
#   }
# }

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "${var.prefix}-${terraform.workspace}-scale-up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.this]
}


# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "${var.prefix}-${terraform.workspace}-scale-down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.this]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.prefix}-${terraform.workspace}-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "30"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${var.prefix}-${terraform.workspace}-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "30"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}

resource "aws_cloudwatch_metric_alarm" "service_memory_high" {
  alarm_name          = "${var.prefix}-${terraform.workspace}-memory-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "30"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}


resource "aws_cloudwatch_metric_alarm" "service_memory_down" {
  alarm_name          = "${var.prefix}-${terraform.workspace}-memory-utilization-down"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "30"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}


resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.prefix}-${terraform.workspace}"
  retention_in_days = 30

  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-log-group"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "${var.prefix}-${terraform.workspace}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}




