# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "app_subnet_ids" {
#   value = module.vpc.app_subnets
# }

# output "public_subnet_ids" {
#   value = module.vpc.public_subnets
# }

# output "data_subnet_ids" {
#   value = module.vpc.data_subnets
# }

# output "nat_gw_id" {
#   value = module.vpc.nat_gw_id
# }


# output "oidc_provider_arn" {
#   description = "The ARN of the OIDC Provider."
#   value       = module.github_oidc.oidc_provider_arn
# }

# output "oidc_provider_url" {
#   description = "The URL of the OIDC Provider (without https://)."
#   value       = module.github_oidc.oidc_provider_url
# }

output "role_arns" {
  description = "A map of role names to their ARNs."
  value       = module.github_oidc.role_arns
}

# output "role_names" {
#   description = "A list of the names of the created IAM roles."
#   value       = module.github_oidc.role_names
# }