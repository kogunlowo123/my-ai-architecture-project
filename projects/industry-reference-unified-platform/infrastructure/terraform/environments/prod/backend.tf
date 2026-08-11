terraform {
  backend "s3" {
    bucket         = "aup-terraform-state-ACCOUNT_ID"
    key            = "prod/platform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aup-terraform-locks"
    encrypt        = true
  }
}
