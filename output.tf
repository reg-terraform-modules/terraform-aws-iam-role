output "arn" {
  description = "IAM role arn"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "IAM role name"
  value = aws_iam_role.this.name
}