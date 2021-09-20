provider "aws" {
  version = "~> 3.0"
  region  = var.region
  profile = var.profile
  shared_credentials_file = "$HOME/.aws/credentials"
}