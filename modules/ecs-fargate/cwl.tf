resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.ecs.name}"
}
