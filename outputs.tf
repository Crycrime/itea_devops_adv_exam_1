output "ansible_instance_id" {
  value       = aws_instance.ec2_ansible.id
  description = "Id of AWS server_instance"
}

output "ansible_ip_addr" {
  value       = aws_eip.my_static_ip.public_ip
  description = "Ansible public IP"
}
