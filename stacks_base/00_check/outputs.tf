output "info" {
  value = {
    global     = local.global
    common_all = local.common_all
    common_env = local.common_env

    aws_account_id = data.aws_caller_identity.current.account_id
    aws_region     = data.aws_region.current.id
  }
}
