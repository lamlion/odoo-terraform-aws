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


# Copies the file as the ubuntu user using SSH
provisioner "file" {
    source = "odoo_apache.conf"
    destination = "/etc/apache2/sites-available/odoo.conf"
    destination = "/tmp/odoo_apache.conf"
 	connection {
                  type = "ssh"
                  user = "ubuntu"
                  private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
                  }
}


  provisioner "remote-exec"	{
			inline = [

				# Odoo prerequisites

			"sudo wget -O - https://nightly.odoo.com/odoo.key | sudo apt-key add -",
			"sudo echo \"deb http://nightly.odoo.com/10.0/nightly/deb/ ./\" >> /etc/apt/sources.list",
			"sudo adduser --system --home=/opt/odoo --group odoo",
			"sudo mkdir -p /var/lib/odoo",
			"sudo apt-get update -y", 

			"sudo apt-get install -y python-cups python-dateutil python-decorator python-docutils python-feedparser",
			"sudo apt-get install -y python-gdata python-geoip python-gevent python-imaging python-jinja2 python-ldap python-libxslt1", 
			"sudo apt-get install -y python-lxml python-mako python-mock python-openid python-passlib python-psutil python-psycopg2", 
			"sudo apt-get install -y python-pybabel python-pychart python-pydot python-pyparsing python-pypdf python-reportlab python-requests", 
			"sudo apt-get install -y python-simplejson python-tz python-unicodecsv python-unittest2 python-vatnumber python-vobject", 
			"sudo apt-get install -y python-werkzeug python-xlwt python-yaml wkhtmltopdf",
			"sudo apt-get install -y odoo",

				# Install and configure Apache Reverse proxy for odoo

			"sudo apt-get install apache2 -y",
			"sudo apt-get install libapache2-mod-proxy-html libxml2-dev -y",
			"sudo apt-get install -y build-essential",
			"sudo a2enmod proxy",
			"sudo a2enmod proxy_http",
			"sudo a2enmod proxy_ajp",
			"sudo a2enmod rewrite",
			"sudo a2enmod deflate",
			"sudo a2enmod headers", 
			"sudo a2enmod proxy_balancer",
			"sudo a2enmod proxy_connect",
			"sudo a2enmod proxy_html",
			"sudo a2dissite 000-default",
			"sudo mv /tmp/odoo_apache.conf /etc/apache2/sites-available/odoo.conf"
				]
				connection {
       				type = "ssh"
       				user = "ubuntu"
       				private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
    					    }
    			}





### remote-exec provisioner for creating and enabling Apache Odoo reverse proxy virtualhost
 provisioner "remote-exec"     {
                        inline = [
                        "sudo a2ensite odoo"
                                ]
                                connection {
                                type = "ssh"
                                user = "ubuntu"
                                private_key = "${file("${var.PATH_PRIVATE_SSH_KEY}")}"
                                            }
                        }


}
### End of provisioner Odoo reverse proxy virtualhost


### Create AWS keypair with public key

resource "aws_key_pair" "devopskey1" {
  key_name = "devopskey1"
  public_key = "${file("${var.PATH_PUBLIC_SSH_KEY}")}"
}
### End of resource aws_key_pair


### Create Cloudflare DNS CNAME with proxy

resource "cloudflare_record" "odoo_get2it_eu" {
    domain = "get2it.eu"
    name = "odoo"
    value = "${aws_elb.elb-odoo.dns_name}" 
    type = "CNAME"
    ttl  = "1"
    proxied = "true" 
}

# Create Cloudflare DNS CNAME without proxy for direct access - ONLY FOR TESTING PURPOSES

resource "cloudflare_record" "odooweb_get2it_eu" {
    domain = "get2it.eu"
    name = "odoo-web1"
    value = "${aws_elb.elb-odoo.dns_name}" 
    type = "CNAME"
    ttl  = "1"
    proxied = "false" 
}
