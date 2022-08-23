output "ecsTaskExecutionRole" {
  value = aws_iam_role.ecsTaskExecutionRole.name
}

output "ecsTaskExecutionRole_arn" {
  value = aws_iam_role.ecsTaskExecutionRole.arn
}
