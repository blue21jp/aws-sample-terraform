locals {
  global = {
    unit = "blue21"
    git  = "/sandbox"

    base_vpc = {
      prefix = "base"
      cidr   = "10.1.0.0/16"
      public = [
        "10.1.0.0/24",
        "10.1.1.0/24"
      ]
      private = [
        "10.1.2.0/24",
        "10.1.3.0/24"
      ]
    }

  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
