http https://cloud-images.ubuntu.com/locator/ec2/releasesTable |grep eu-west-1|grep 16.04|grep amd64|grep "hvm:ebs-ssd"
echo ""| ssh-keygen -t rsa -q -C beheer-key -f ./beheer-key
https://www.cloudflare.com/ips-v4
https://ip-ranges.amazonaws.com/ip-ranges.json
http http://httpbin.org/ip |grep origin|awk '{print $2'} |sed -e 's/^"//' -e 's/"$//'
http http://httpbin.org/ip |grep origin|awk '{print $2'} |tr -d '"'
wget -qO - http://httpbin.org/ip | grep origin|awk '{print $2'} |tr -d '"'
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 365




# Odoo dependencies Ubuntu 16.04

sudo adduser --system --home=/opt/odoo --group odoo
mkdir -p /var/lib/odoo

wget -O - https://nightly.odoo.com/odoo.key | apt-key add -

echo "deb http://nightly.odoo.com/8.0/nightly/deb/ ./" >> /etc/apt/sources.list
sudo apt-get update


sudo apt-get install python-cups python-dateutil python-decorator python-docutils python-feedparser \
python-gdata python-geoip python-gevent python-imaging python-jinja2 python-ldap python-libxslt1 \
python-lxml python-mako python-mock python-openid python-passlib python-psutil python-psycopg2 \
python-pybabel python-pychart python-pydot python-pyparsing python-pypdf python-reportlab python-requests \
python-simplejson python-tz python-unicodecsv python-unittest2 python-vatnumber python-vobject \
python-werkzeug python-xlwt python-yaml wkhtmltopdf

# Add lines to odoo.conf

xmlrpc_interface = 127.0.0.1
xmlrpc_port = 8069

