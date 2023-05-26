terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # localstackは、これより新しいとVPC作成でエラーになる
      version = "4.34.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 1.3.6"
}
