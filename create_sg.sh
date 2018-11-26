#!/bin/bash

# Fetch Cloudflare ipv4 ranges from Cloudflare website
wget -qO cloudflare_ips.txt https://www.cloudflare.com/ips-v4

# Check if rulebase file exist and remove before generating a new one
file="securitygroups.tf"

if [ -f $file ] ; then
    rm $file
fi


#localip=`wget -qO - http://httpbin.org/ip | grep origin|awk '{print $2'} |tr -d '"'`
localip=$(curl -s https://api.ipify.org)

### Tier 1 security group creation

cloudflare_ips="cloudflare_ips.txt"
rulenum="1"
echo "# Tier 1 rules" >> securitygroups.tf
echo "resource \"aws_security_group\" \"cloudflare-access\" {" >> securitygroups.tf
echo "			name        = \"cloudflare-access-sg\"" >> securitygroups.tf
echo "			description = \"Security group CloudFlare for webapps\"" >> securitygroups.tf
echo "			vpc_id      = \"\${aws_vpc.webapps.id}\"" >> securitygroups.tf
while read -r line
do
    cidrblock="$line"
	echo "" >> securitygroups.tf
	echo "		#$rulenum Imported Cloudflare ip range $cidrblock" >> securitygroups.tf
	echo "		ingress {" >> securitygroups.tf

	echo "		from_port	= 443" >> securitygroups.tf
	echo "		to_port 	= 443" >> securitygroups.tf
	echo "		protocol 	= \"tcp\"" >> securitygroups.tf
	echo " 		cidr_blocks	= [\"$cidrblock\"]" >> securitygroups.tf
	echo "		}" >> securitygroups.tf
    let rulenum="rulenum+1" 
done < "$cloudflare_ips"

public="public_source_ips.txt"
rulenum="1"

while read line; do
  case "$line" in \#*) continue ;; esac
  cidrblock="$line"

        echo "" >> securitygroups.tf
        echo "          # Imported public source ip range $cidrblock" >> securitygroups.tf
        echo "          ingress {" >> securitygroups.tf
        echo "          from_port       = 443" >> securitygroups.tf
        echo "          to_port         = 443" >> securitygroups.tf
        echo "          protocol        = \"tcp\"" >> securitygroups.tf
        echo "          cidr_blocks     = [\"$cidrblock\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf
 let rulenum="rulenum+1"
done < public_source_ips.txt

# Add local ip as rule to Cloudflare access security group

        echo "" >> securitygroups.tf
        echo "          # Local public source ip address $localip" >> securitygroups.tf
        echo "          ingress {" >> securitygroups.tf
        echo "          from_port       = 443" >> securitygroups.tf
        echo "          to_port         = 443" >> securitygroups.tf
        echo "          protocol        = \"tcp\"" >> securitygroups.tf
        echo "          cidr_blocks     = [\"$localip/32\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf



# Outbound rules 	
	echo "" >> securitygroups.tf	
 	echo "		# outbound internet access" >> securitygroups.tf
  	echo "		egress {" >> securitygroups.tf
    	echo "		from_port   = 0" >> securitygroups.tf
    	echo "		to_port     = 0" >> securitygroups.tf
    	echo "		protocol    = \"-1\"" >> securitygroups.tf
    	echo "		cidr_blocks = [\"0.0.0.0/0\"]" >> securitygroups.tf
  	echo "		}" >> securitygroups.tf

echo "}" >> securitygroups.tf

### Tier 2 security group creation

echo "# Tier 2 rules"	>> securitygroups.tf
echo "resource \"aws_security_group\" \"directpublicaccess\" {" >> securitygroups.tf
echo "                  name        = \"directpublicaccess-sg\"" >> securitygroups.tf
echo "                  description = \"Security group for direct public access to webapps\"" >> securitygroups.tf
echo "                  vpc_id      = \"\${aws_vpc.webapps.id}\"" >> securitygroups.tf

# Add local ip as rule to tier 2 security group

        echo "" >> securitygroups.tf
        echo "          # Local public source ip address $localip" >> securitygroups.tf
        echo "          ingress {" >> securitygroups.tf
        echo "          from_port       = 80" >> securitygroups.tf
        echo "          to_port         = 80" >> securitygroups.tf
        echo "          protocol        = \"tcp\"" >> securitygroups.tf
        echo "          cidr_blocks     = [\"$localip/32\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf

# Add ELB ip source as rule to tier 2 security group

        echo "" >> securitygroups.tf
        echo "          # ELB source ip range 192.168.128.0/22" >> securitygroups.tf
        echo "          ingress {" >> securitygroups.tf
        echo "          from_port       = 80" >> securitygroups.tf
        echo "          to_port         = 80" >> securitygroups.tf
        echo "          protocol        = \"tcp\"" >> securitygroups.tf
        echo "          cidr_blocks     = [\"192.168.128.0/22\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf

# Outbound rules 
        echo "" >> securitygroups.tf
        echo "          # outbound internet access" >> securitygroups.tf
        echo "          egress {" >> securitygroups.tf
        echo "          from_port   = 0" >> securitygroups.tf
        echo "          to_port     = 0" >> securitygroups.tf
        echo "          protocol    = \"-1\"" >> securitygroups.tf
        echo "          cidr_blocks = [\"0.0.0.0/0\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf
echo "}" >> securitygroups.tf

### Management tier security group creation

echo "# Management Tier rules"	>> securitygroups.tf
echo "resource \"aws_security_group\" \"mgttier\" {" >> securitygroups.tf
echo "                  name        = \"mgttier-sg\"" >> securitygroups.tf
echo "                  description = \"Security group for remote management\"" >> securitygroups.tf
echo "                  vpc_id      = \"\${aws_vpc.webapps.id}\"" >> securitygroups.tf

# Add local ip as rule to mgt tier security group

        echo "" >> securitygroups.tf
        echo "          # Local public source ip address $localip" >> securitygroups.tf
        echo "          ingress {" >> securitygroups.tf
        echo "          from_port       = 22" >> securitygroups.tf
        echo "          to_port         = 22" >> securitygroups.tf
        echo "          protocol        = \"tcp\"" >> securitygroups.tf
        echo "          cidr_blocks     = [\"$localip/32\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf

# Outbound rules 
        echo "" >> securitygroups.tf
        echo "          # outbound internet access" >> securitygroups.tf
        echo "          egress {" >> securitygroups.tf
        echo "          from_port   = 0" >> securitygroups.tf
        echo "          to_port     = 0" >> securitygroups.tf
        echo "          protocol    = \"-1\"" >> securitygroups.tf
        echo "          cidr_blocks = [\"0.0.0.0/0\"]" >> securitygroups.tf
        echo "          }" >> securitygroups.tf
echo "}" >> securitygroups.tf
