data "aws_ami" "main" {
  count = local.common_env.env_type == "dev" ? 0 : 1

  most_recent = true
  owners      = ["amazon"]

  dynamic "filter" {
    for_each = local.ami_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}

module "ec2_work" {
  for_each = local.ec2_list

  source = "../../modules/ec2-spot"
  common = local.common_all
  ec2 = {
    name              = "${local.common_all.project}-${each.value.name}"
    instance_type     = each.value.instance_type
    key_name          = each.value.key_name
    enable_monitoring = false
    image_id          = each.value.image_id
    security_groups   = [aws_security_group.main[each.key].id]
    subnet_id         = data.aws_subnet.private[0].id
    enable_public_ip  = false
    source_dest_check = false
    user_data         = ""
  }
}

resource "aws_security_group" "main" {
  for_each = local.ec2_list

  name        = "${local.common_all.project}-${each.value.name}-ec2"
  description = "work server"
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
    Name = "${local.common_all.project}-${each.value.name}-ec2"
  }
}
