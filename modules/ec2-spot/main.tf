# Iam Role
data "aws_iam_policy_document" "main" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = "${var.ec2.name}-role"
  assume_role_policy = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.main.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

data "aws_iam_policy_document" "addon" {
  statement {
    actions = [
      # for NAT
      "ec2:ModifyInstanceAttribute"
    ]
    resources = [
      "*"
    ]
  }
}
resource "aws_iam_policy" "addon" {
  policy = data.aws_iam_policy_document.addon.json
}
resource "aws_iam_role_policy_attachment" "addon" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.addon.arn
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.ec2.name}-profile"
  role = aws_iam_role.main.name
}

# launch template
resource "aws_launch_template" "main" {
  name = var.ec2.name
  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type             = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }
  instance_type = var.ec2.instance_type
  key_name      = var.ec2.key_name
  image_id      = var.ec2.image_id
  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }
  instance_initiated_shutdown_behavior = "terminate"
  monitoring {
    enabled = false
  }
  network_interfaces {
    associate_public_ip_address = var.ec2.enable_public_ip
  }
}

# Instance
resource "aws_instance" "main" {
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  subnet_id              = var.ec2.subnet_id
  vpc_security_group_ids = var.ec2.security_groups
  source_dest_check      = var.ec2.source_dest_check
  user_data              = var.ec2.user_data
  tags = {
    Name = var.ec2.name
  }
}
