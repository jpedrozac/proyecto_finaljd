terraform {
  backend "s3" {
    bucket = "terraform-infra-coe2"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}