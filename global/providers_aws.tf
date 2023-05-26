provider "aws" {
  profile = local.common_env.profile
  region  = local.common_env.region
  default_tags {
    tags = {
      "ResourceGroup" = local.common_all.project
      "Git"           = local.global.git
      "Environment"   = local.common_env.env_type
      "Author"        = local.common_all.author
      "Buidler"       = "terraform"
    }
  }
}
