locals {
  url_stripped = replace(var.oidc_provider_url, "https://", "")

  # Flattens the map so Terraform can iterate over role-policy pairs
  role_policy_attachments = flatten([
    for role_name, details in var.github_actions_roles : [
      for policy_arn in details.policy_arns : {
        role_name  = role_name
        policy_arn = policy_arn
      }
    ]
  ])
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = var.oidc_provider_url
  client_id_list  = var.oidc_audience
}

# Generate unique Trust Policies for each role
data "aws_iam_policy_document" "oidc_trust" {
  for_each = var.github_actions_roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.url_stripped}:aud"
      values   = var.oidc_audience
    }

    condition {
      test     = "StringLike"
      variable = "${local.url_stripped}:sub"
      values   = each.value.allowed_subjects
    }
  }
}

# Create the Roles
resource "aws_iam_role" "this" {
  for_each           = var.github_actions_roles
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.oidc_trust[each.key].json
}

# Attach the Policies (using a unique key for the map)
resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for pair in local.role_policy_attachments : "${pair.role_name}-${pair.policy_arn}" => pair
  }

  role       = aws_iam_role.this[each.value.role_name].name
  policy_arn = each.value.policy_arn
}