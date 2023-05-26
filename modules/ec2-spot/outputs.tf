output "ec2" {
  value = {
    instance_id = aws_instance.main.id
    network_interface_id = aws_instance.main.primary_network_interface_id
  }
}
