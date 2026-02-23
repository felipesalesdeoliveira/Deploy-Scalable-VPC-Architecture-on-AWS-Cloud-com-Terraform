terraform {
  backend "s3" {
    bucket         = "felipe-terraform-state-prod"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}