terraform {
  backend "s3" {
    bucket         = "terraform-aws-modules"
    key            = "vpc/advanced-tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.35.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}