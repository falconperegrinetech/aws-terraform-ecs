output "subnet_a_id" {
  value = aws_default_subnet.default_subnet_a.id
}

output "subnet_b_id" {
  value = aws_default_subnet.default_subnet_b.id
}

output "subnet_c_id" {
  value = aws_default_subnet.default_subnet_c.id
}

output "db_subnet_id" {
  value = aws_db_subnet_group.db_subnet.id
}

output "db_subnet_name" {
  value = aws_db_subnet_group.db_subnet.name
}

