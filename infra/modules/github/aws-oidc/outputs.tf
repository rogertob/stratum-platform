output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider. Use this to create additional roles manually."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  description = "The URL of the OIDC Provider (without https://)."
  value       = local.url_stripped
}

output "role_arns" {
  description = "A map of role names to their ARNs. Copy these into your GitHub Actions 'role-to-assume' field."
  value       = { for name, role in aws_iam_role.this : name => role.arn }
}

output "role_names" {
  description = "A list of the names of the created IAM roles."
  value       = [for role in aws_iam_role.this : role.name]
}