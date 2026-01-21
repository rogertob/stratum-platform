variable "aws_region" {
  description = "AWS Region to be used for resource creation"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR Block that will be used to create the AWS VPC"
  type        = string
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "create_nat_gw_regional" {
  description = "Whether to create a regional NAT that automatically expands across different Availability Zones"
  type        = bool
  default     = true
}

variable "app_subnets" {
  description = "Application subnets keyed by name"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "public_subnets" {
  description = "Public subnets keyed by name"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "data_subnets" {
  description = "Data subnets keyed by name"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

## GitHub OIDC 
variable "oidc_provider_url" {
  type        = string
  description = "The URL of the OIDC identity provider. This must be an HTTPS URL (e.g., https://token.actions.githubusercontent.com) and serve as the issuer identifier for the tokens."
}

variable "oidc_audience" {
  type        = list(string)
  description = "The audience (Client ID) for the OIDC provider. This identifies the intended recipient of the token and must match the 'aud' claim in the OIDC token (e.g., 'sts.amazonaws.com' for GitHub Actions)."
}

variable "github_actions_roles" {
  type = map(object({
    policy_arns      = list(string)
    allowed_subjects = list(string)
  }))
  description = "A map of IAM roles to create. Key is the role name suffix."
}