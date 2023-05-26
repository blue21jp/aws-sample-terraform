# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.ecs.name

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.main.name
      }
    }
  }
}
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 0
    weight            = 0
  }
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = var.ecs.name
  cluster         = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.ecs.desired_count
  # これを指定すると capacity_provider を設定できない
  #launch_type                       = "FARGATE"
  platform_version       = "1.4.0"
  enable_execute_command = true

  network_configuration {
    assign_public_ip = true
    security_groups  = var.ecs.security_groups
    subnets          = var.vpc.subnet_id
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      # デプロイ毎にタスク定義が更新されるため、リソース初回作成時を除き変更を無視
      task_definition,
      # NOTE: https://github.com/terraform-providers/terraform-provider-aws/issues/11351
      capacity_provider_strategy
    ]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 0
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = var.ecs.name
  cpu                      = var.ecs.cpu
  memory                   = var.ecs.memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = var.ecs.container_definitions
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}
