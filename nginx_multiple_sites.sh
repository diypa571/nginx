#!/bin/bash
# Diypa571, Diyar Par
# Linköping 2023-06-01
  
# Install nginx
sudo apt-get update
sudo apt-get install nginx


# create directories
sudo mkdir -p /var/www/test.com/public_html
sudo mkdir -p /var/www/example.com/public_html

# set permissions
sudo chown -R livia:livia /var/www/test.com/public_html
sudo chown -R livia:livia /var/www/example.com/public_html
sudo chmod -R 755 /var/www/test.com
sudo chmod -R 755 /var/www/example.com

# create test pages
echo "<html><body><h1>Test site</h1></body></html>" | sudo tee /var/www/test.com/public_html/index.html
echo "<html><body><h1>Example site</h1></body></html>" | sudo tee /var/www/example.com/public_html/index.html

# create nginx server block files
echo "server {
    listen 80;
    listen [::]:80;
    
    root /var/www/test.com/public_html;
    index index.html index.htm index.nginx-debian.html;
    
    server_name test.com www.test.com;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}" | sudo tee /etc/nginx/sites-available/test.com

echo "server {
    listen 80;
    listen [::]:80;
    
    root /var/www/example.com/public_html;
    index index.html index.htm index.nginx-debian.html;
    
    server_name example.com www.example.com;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}" | sudo tee /etc/nginx/sites-available/example.com

# enable sites
sudo ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

# test nginx config and restart if successful
sudo nginx -t && sudo systemctl restart nginx
