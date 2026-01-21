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