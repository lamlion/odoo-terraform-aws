# AWS provider for user terraform in your AWS account
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "eu-central-1"}

# Cloudflare provider for your account with variables defined in example.tfvars and copied to terraform.tfvars
provider "cloudflare" {
	email = "${var.CLOUDFLARE_EMAIL}"
	token = "${var.CLOUDFLARE_TOKEN}"
}
