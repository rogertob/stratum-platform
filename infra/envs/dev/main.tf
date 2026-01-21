locals {
  project_name = "stratum-platform"
  environment  = "dev"
  additional_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "terraform"
    auto-delete = "no"
  }
}

module "vpc" {
  source          = "../../modules/networking/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  name            = local.project_name
  environment     = local.environment
  additional_tags = local.additional_tags
  #Subnets
  app_subnets    = var.app_subnets
  public_subnets = var.public_subnets
  data_subnets   = var.data_subnets
  #Create NAT
  create_nat_gw_regional = var.create_nat_gw_regional
}

module "github_oidc" {
  source               = "../../modules/github/aws-oidc"
  oidc_provider_url    = var.oidc_provider_url
  oidc_audience        = var.oidc_audience
  github_actions_roles = var.github_actions_roles
}


