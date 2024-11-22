variable "business_unit" {
  description = "business_unit"
  type        = string
}

variable "project" {
  description = "project"
  type        = string
}

variable "team" {
  description = "team"
  type        = string
}

#keeping env as a variable thinking that this module might be used in accounts holding multiple env
variable "environment" {
  description = "environment this resource is being provisioned in, possible values: Dev, Staging, Prod"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be a valid value of dev, staging, or prod"
  }
}

variable "provisioned_by" {
  description = "email of the engineer provisioning the resource"
  type        = string
}

variable "enable_nat_gateway" {
  description = "whether to enable nat gateway or not"
  type        = string
}

data "aws_region" "current" {}

locals {
  vpc_name          = "${var.project}-${var.environment}"
  environment       = var.environment
  project           = var.project
  nat_gateway_count = length(var.availability_zones)
  common_tags = {
    business_unit  = var.business_unit
    environment    = var.environment
    project        = var.project
    team           = var.team
    managed_by     = "Terraform"
    provisioned_by = var.provisioned_by
  }
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "default CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.8.0/21", "10.0.16.0/21", "10.0.24.0/21"]
  description = "default CIDR block range for the private subnets"
}

variable "private_subnet_cidr_blocks_with_nat" {
  type        = list(string)
  default     = ["10.0.104.0/21", "10.0.112.0/21", "10.0.120.0/21"]
  description = "default CIDR block range for the private subnets with nat gateway"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.208.0/21", "10.0.216.0/21", "10.0.224.0/21"]
  description = "default CIDR block range for the public subnets"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "default list of availability zones for the selected region"
}