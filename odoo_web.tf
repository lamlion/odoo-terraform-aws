resource "aws_instance" "odoo"
{
  ami           		= "ami-0a974265"
  instance_type 		= "t2.micro"
  availability_zone		= "eu-central-1a"
  key_name			= "devopskey1"
  subnet_id 			= "${aws_subnet.tier12a.id}"
  vpc_security_group_ids 	= ["${aws_security_group.tier2apps.id}", "${aws_security_group.mgttier.id}"]
  root_block_device 		{
				volume_type = "gp2"
				volume_size = "12"
				delete_on_termination = "true"
				}
  tags				{
				Name = "odoo-web1-terraform"
				}

  provisioner "local-exec"	{
        			command = "echo Public IP: ${aws_instance.odoo.public_ip} >> ips.txt"
    				}

  provisioner "local-exec"	{
        			command = "echo Private IP: ${aws_instance.odoo.private_ip} >> ips.txt"
    				}


# Copies files as the ubuntu user using SSH


provisioner "file" {
    source = "files-to-copy/provision_odoo.sh"
    destination = "/tmp/provision_odoo.sh"
 	connection {
                  type = "ssh"
                  user = "ubuntu"
                  private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
                  }
}

provisioner "file" {
    source = "files-to-copy/odoo_apache.conf"
    destination = "/tmp/odoo_apache.conf"
 	connection {
                  type = "ssh"
                  user = "ubuntu"
                  private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
                  }
}

provisioner "file" {
    source = "files-to-copy/odoo.conf"
    destination = "/tmp/odoo.conf"
 	connection {
                  type = "ssh"
                  user = "ubuntu"
                  private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
                  }
}


  provisioner "remote-exec"	{
			inline = [

			"cd /tmp && sudo tar zxvf files.tar.gz",
			"sudo chmod +x /tmp/provision_odoo.sh",
			"/tmp/provision_odoo.sh"

				]
				connection {
       				type = "ssh"
       				user = "ubuntu"
       				private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
    					    }
    			}
}
### Create AWS keypair with public key

resource "aws_key_pair" "devopskey1" {
  key_name = "devopskey1"
  public_key = "${file("${var.PATH_PUBLIC_SSH_KEY}")}"
}
### End of resource aws_key_pair


### Create Cloudflare DNS CNAME with proxy

resource "cloudflare_record" "odoo" {
    domain = "${var.CLOUDFLARE_DOMAIN}"
    name = "odoo"
    value = "${aws_elb.elb-odoo.dns_name}"
    type = "CNAME"
    ttl  = "1"
    proxied = "true"
}

# Create Cloudflare DNS CNAME without proxy for direct access - ONLY FOR TESTING PURPOSES

resource "cloudflare_record" "odooweb" {
    domain = "${var.CLOUDFLARE_DOMAIN}"
    name = "odoo-web1"
    value = "${aws_elb.elb-odoo.dns_name}"
    type = "CNAME"
    ttl  = "1"
    proxied = "false"
}
