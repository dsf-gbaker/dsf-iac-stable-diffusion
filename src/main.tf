terraform {
  
  required_version = "~> 1.2.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "dsf-terraform-state"
    key     = "stable-diffusion/terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Name        = var.project-name
      Owner       = var.owner
    }
  }
}