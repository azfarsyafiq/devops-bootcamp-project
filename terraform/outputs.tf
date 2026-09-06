output "web_server" {
  value = aws_instance.web_server.private_ip
}

output "web_server_ssm_command" {
  value = "aws ssm start-session --target ${aws_instance.web_server.id}"
}

output "ansible_controller" {
  value = aws_instance.ansible_controller.private_ip
}

output "ansible_controller_ssm_command" {
  value = "aws ssm start-session --target ${aws_instance.ansible_controller.id}"
}

output "monitoring_server" {
  value = aws_instance.monitoring_server.public_ip
}

output "monitoring_server_ssm_command" {
  value = "aws ssm start-session --target ${aws_instance.monitoring_server.id}"
}
