output "server_ip_1" {
  value = aws_instance.web_server.public_ip
}

output "ssm_command_1" {
  value = "aws ssm start-session --target ${aws_instance.web_server.id}"
}

output "server_ip_2" {
  value = aws_instance.ansible_controller.public_ip
}

output "ssm_command_2" {
  value = "aws ssm start-session --target ${aws_instance.ansible_controller.id}"
}

output "server_ip_3" {
  value = aws_instance.monitoring_server.public_ip
}

output "ssm_command_3" {
  value = "aws ssm start-session --target ${aws_instance.monitoring_server.id}"
}
