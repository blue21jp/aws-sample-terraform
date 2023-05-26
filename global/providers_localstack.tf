provider "aws" {
  profile = local.common_env.profile
  region  = local.common_env.region
  default_tags {
    tags = {
      "ResourceGroup" = local.common_all.project
      "Git"           = local.global.git
      "Environment"   = local.common_env.env_type
      "Author"        = local.common_all.author
      "Builder"       = "terraform"
    }
  }

  # for localstack
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    sts            = "http://${data.external.myip.result["ip"]}:4566"
    s3             = "http://${data.external.myip.result["ip"]}:4566"
    ec2            = "http://${data.external.myip.result["ip"]}:4566"
    route53        = "http://${data.external.myip.result["ip"]}:4566"
    cloudwatch     = "http://${data.external.myip.result["ip"]}:4566"
    iam            = "http://${data.external.myip.result["ip"]}:4566"
    eks            = "http://${data.external.myip.result["ip"]}:4566"
    wafregional    = "http://${data.external.myip.result["ip"]}:4566"
    wafv2          = "http://${data.external.myip.result["ip"]}:4566"
    waf            = "http://${data.external.myip.result["ip"]}:4566"
    cloudfront     = "http://${data.external.myip.result["ip"]}:4566"
    lambda         = "http://${data.external.myip.result["ip"]}:4566"
    secretsmanager = "http://${data.external.myip.result["ip"]}:4566"
    cloudformation = "http://${data.external.myip.result["ip"]}:4566"
    ssm            = "http://${data.external.myip.result["ip"]}:4566"
  }
}

data "external" "myip" {
  program = ["bash", "../../global/ip.sh"]
}
