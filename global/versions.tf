terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 1.3.6"
}
