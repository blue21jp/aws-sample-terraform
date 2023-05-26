locals {

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
