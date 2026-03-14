terraform {
  required_version = "~> 1.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "lab-cloud-terraform-user"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "lab-cloud-terraform-user"
}
