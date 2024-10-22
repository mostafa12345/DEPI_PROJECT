terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
     bucket = "testasdawf4115154"
     key    = "terraform.tfstate"
    region  = "us-east-1"
  }
}

# Configure aws provider
provider "aws" {
  region  = "us-east-1"
}
