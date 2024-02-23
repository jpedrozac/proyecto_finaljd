terraform {
  backend "s3" {
    bucket = "proyecto-finaljd"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}