#!/usr/bin/env bash
# installs nginx
apt-get -y update
apt-get -y install nginx
sed -i "/listen \[::\]:80 default_server/ a\\\trewrite ^/redirect_me http://www.holbertonschool.com permanent;" /etc/nginx/sites-available/default
sed -i "/listen \[::\]:80 default_server/ a\\\tadd_header X-Served-By \"\$HOSTNAME\";" /etc/nginx/sites-available/default
sed -i "/redirect_me/ a\\\terror_page 404 /custom_404.html;" /etc/nginx/sites-available/default
# echo "Ceci n'est pas une page" > /var/www/html/custom_404.html
service nginx start
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/
echo "Hello Holberton School!" > /data/web_static/releases/test/index.html
ln -sf /data/web_static/releases/test/ /data/web_static/current
chown -R ubuntu:ubuntu /data/
sed -i "/^\tlocation \/ {$/ i\\\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t\tautoindex off;\n}" /etc/nginx/sites-available/default
service nginx restart
exit 0