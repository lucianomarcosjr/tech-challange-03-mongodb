provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "mongodbatlas" {
  public_key  = var.mongodb_atlas_public_key
  private_key = var.mongodb_atlas_private_key
}

terraform {
  backend "s3" {
    bucket = "fiapfastapi"
    key    = "terraform-mongodb.tfstate"
    region = "us-east-1"
  }
}
