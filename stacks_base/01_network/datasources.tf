data "aws_availability_zones" "az_names" {}
data "aws_availability_zone" "az" {
  count = length(data.aws_availability_zones.az_names.names)
  name  = data.aws_availability_zones.az_names.names[count.index]
}
