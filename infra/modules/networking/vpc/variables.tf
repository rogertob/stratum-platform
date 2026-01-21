variable "vpc_cidr_block" {
  description = "CIDR Block that will be used to create the AWS VPC"
  type        = string
}
# https://developer.hashicorp.com/terraform/language/expressions/types#list


variable "name" {}

variable "environment" {}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "app_subnets" {
  description = "Application layer subnets keyed by name"
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
  description = "Data layer subnets keyed by name"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "create_nat_gw_regional" {
  description = "Whether to create a regional NAT that automatically expands across different Availability Zones"
  type        = bool
}
