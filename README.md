
# Automate Odoo 10 deployment on AWS with Terraform in Multi AZ setup

## Building blocks used:

- AWS EC2
- AWS ELB
- AWS RDS
- CloudFlare

## Preliminary tasks
====================

1) Download and install [Terraform](https://www.terraform.io/downloads.html).
Place the terraform binary in your environment path.

2) Create RSA keypair for accessing EC2 instance. Public key will be copied to EC2 instance.

In OSX or Linux use the following command:

```
echo ""| ssh-keygen -t rsa -q -C devopskey1 -f secrets/devopskey1
```


3) Create RSA keypair for using TLS on Odoo reverse proxy servers

```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 730
```


4) Run Terraform


```
terraform plan -out anyfile.tfout```


```
terraform apply anyfile.tfout```
