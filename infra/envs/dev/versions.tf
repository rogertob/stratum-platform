terraform {
  required_version = ">= 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
  }
  # Cannot reference any ENV for the backend
  backend "s3" {
    bucket = "devops-aws-project-tfstate-dev"
    key    = "stratum-dev"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

