#!/bin/bash


# Odoo prerequisites


			wget -qO - https://nightly.odoo.com/odoo.key | sudo apt-key add -
                        echo "deb http://nightly.odoo.com/10.0/nightly/deb/ ./" | sudo tee --append /etc/apt/sources.list > /dev/null
                        sudo adduser --system --home=/opt/odoo --group odoo
                        sudo mkdir -p /var/lib/odoo
                        sudo apt-get update -y

			sudo apt-get install postgresql -y
			sudo -u postgres bash -c "psql -c \"CREATE USER odoo WITH PASSWORD 'odoo';\""

                        sudo apt-get install -y python-cups python-dateutil python-decorator python-docutils python-feedparser
                        sudo apt-get install -y python-gdata python-geoip python-gevent python-imaging python-jinja2 python-ldap python-libxslt1
                        sudo apt-get install -y python-lxml python-mako python-mock python-openid python-passlib python-psutil python-psycopg2
                        sudo apt-get install -y python-pybabel python-pychart python-pydot python-pyparsing python-pypdf python-reportlab python-requests
                        sudo apt-get install -y python-simplejson python-tz python-unicodecsv python-unittest2 python-vatnumber python-vobject
                        sudo apt-get install -y python-werkzeug python-xlwt python-yaml wkhtmltopdf
                        sudo apt-get install -y odoo

                                # Install and configure Apache Reverse proxy for odoo

                        sudo apt-get install apache2 -y
                        sudo apt-get install libapache2-mod-proxy-html libxml2-dev -y
                        sudo apt-get install -y build-essential
                        sudo a2enmod proxy
                        sudo a2enmod proxy_http
                        sudo a2enmod proxy_ajp
                        sudo a2enmod rewrite
                        sudo a2enmod deflate
                        sudo a2enmod headers
                        sudo a2enmod proxy_balancer
                        sudo a2enmod proxy_connect
                        sudo a2enmod proxy_html
                        sudo a2dissite 000-default
                        sudo mv /tmp/odoo_apache.conf /etc/apache2/sites-available/odoo.conf
			sudo a2ensite odoo
			sudo service apache2 restart
