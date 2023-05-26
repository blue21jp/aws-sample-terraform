data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# task role
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.ecs.name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "ecsexec" {
  version = "2012-10-17"
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecsexec" {
  name_prefix = "${var.ecs.name}-ecsexec"
  policy      = data.aws_iam_policy_document.ecsexec.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_ecsexec" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecsexec.arn
}

# task exec role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs.name}-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_basic" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_ssm" {
#  role       = "aws_iam_role.ecs_task_execution_role.name"
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
#}
