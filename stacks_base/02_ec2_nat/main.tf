data "aws_ami" "main" {
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

module "ec2_nat" {
  source = "../../modules/ec2-spot"
  common = local.common_all
  ec2 = {
    name              = local.ec2_name
    instance_type     = "t3.nano"
    key_name          = "sandbox"
    enable_monitoring = "false"
    image_id          = data.aws_ami.main.id
    security_groups   = [aws_security_group.main.id]
    subnet_id         = data.aws_subnet.public[0].id
    enable_public_ip  = true
    source_dest_check = false
    user_data         = <<EOF
#!/bin/bash
INSTANCEID=$(curl -s -m 60 http://169.254.169.254/latest/meta-data/instance-id)
aws --region us-east-1 ec2 modify-instance-attribute --instance-id $INSTANCEID --source-dest-check "{\"Value\": false}"
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
EOF
  }
}

resource "aws_security_group" "main" {
  name        = "${local.ec2_name}-ec2"
  description = "nat"
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.ec2_name}-ec2"
  }
}

data "aws_route_table" "private" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "${local.global.base_vpc.prefix}-private"
  }
}

resource "aws_route" "nat" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_nat.ec2.network_interface_id
}
