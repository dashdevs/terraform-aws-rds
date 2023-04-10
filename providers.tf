terraform {
  backend "s3" {}
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      project = var.name
    }
  }
}
