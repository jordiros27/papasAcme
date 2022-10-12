output "private_ip_app" {
    value = try(aws_instance.app-ec2.private_ip, "")
}