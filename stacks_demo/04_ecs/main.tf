module "ecs-fargate" {
  for_each = local.ecs_list

  source = "../../modules/ecs-fargate"
  common = local.common_all
  ecs = {
    name                  = "${local.common_all.project}-${each.value.name}"
    container_definitions = file(each.value.container_definitions)
    cpu                   = "256"
    memory                = "512"
    desired_count         = 1
    security_groups       = [aws_security_group.main[each.key].id]
  }
  vpc = {
    vpc_id    = data.aws_vpc.main.id
    subnet_id = data.aws_subnet.public[*].id
  }
}

resource "aws_security_group" "main" {
  for_each = local.ecs_list

  name        = "${local.common_all.project}-${each.key}-ecs"
  description = "for ecs"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.sg_default_ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
      self            = ingress.value.self
      cidr_blocks     = ingress.value.cidr_blocks
    }
  }

  dynamic "ingress" {
    for_each = each.value.sg_ingress
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
      self            = ingress.value.self
      cidr_blocks     = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.common_all.project}-${each.value.name}-ecs"
  }
}

