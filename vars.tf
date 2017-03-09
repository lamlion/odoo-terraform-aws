variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-central-1"
}
variable "PATH_PRIVATE_SSH_KEY" {}
variable "PATH_PUBLIC_SSH_KEY" {}
variable "CLOUDFLARE_EMAIL" {}
variable "CLOUDFLARE_TOKEN" {}
variable "SECRET_PATH" {default = "secrets/"}
