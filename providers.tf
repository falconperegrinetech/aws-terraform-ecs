terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.1"
    }
  }
  backend "s3" {
    bucket = "ecs-api-terraform-tfstate"
    key    = "state.tfstate"
    region = "us-east-2"
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.default_region
}

