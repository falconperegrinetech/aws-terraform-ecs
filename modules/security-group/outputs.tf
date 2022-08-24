output "load_balancer_id" {
  value = aws_security_group.load_balancer.id
}

output "service_security_group_id" {
  value = aws_security_group.service_security_group.id
}

output "sg_postgres_id" {
  value = aws_security_group.postgres.id
}
