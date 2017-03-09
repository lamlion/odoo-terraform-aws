# AWS provider for user terraform in account awsfreetier-i
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "eu-central-1"}

# Cloudflare provider for account lamlion.feisal@gmail.com with variables defined in secrets.tfvars
provider "cloudflare" {
	email = "${var.CLOUDFLARE_EMAIL}"
	token = "${var.CLOUDFLARE_TOKEN}"
}

