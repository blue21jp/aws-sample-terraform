locals {

  // AmazonLinux2 AMI
  ami_filters = [
    {
      name   = "architecture"
      values = ["x86_64"]
    },
    {
      name   = "root-device-type"
      values = ["ebs"]
    },
    {
      name   = "name"
      values = ["amzn2-ami-hvm-*"]
    },
    {
      name   = "virtualization-type"
      values = ["hvm"]
    },
    {
      name   = "block-device-mapping.volume-type"
      values = ["gp2"]
    }
  ]

  // SecurityGroup Ingress
  sg_default_ingress = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = []
      self            = true
      cidr_blocks     = []
    },
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = []
      self            = false
      cidr_blocks     = [local.global.base_vpc.cidr]
    }
  ]
}
