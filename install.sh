sudo apt-get install nginx
sudo apt-get install php5 php5-fpm php5-cgi php5-cli php5-common
sudo mkdir /var/www
sudo chmod 775 /var/www -R 
sudo chown www-data:www-data /var/www
sudo mkdir /var/www/local
sudo chown www-data:www-data /var/www/local

#sudo nano /etc/nginx/sites-available/local
sudo cat <<'EOF' >> /etc/nginx/sites-available/local
server
{
    access_log /var/log/nginx/local.access.log;
    error_log /var/log/nginx/local.error.log;

    #Error Redirect
    error_page 404 /404.html;

    ### Default location
    root /var/www/local;
    index index.php index.html index.htm;

    ### Static content passed through
    location ~* ^.+.(jpg|jpeg|gif|css|png|js|ico|xml)$ {
        expires 5d;
        access_log off;
    }

    if (-f .php) {
        rewrite ^(.*)$ /.php;
    }

    # use fastcgi for all php files
    location ~ \.php
    {
        try_files  =404;
        include /etc/nginx/fastcgi_params;
        keepalive_timeout 0;
        fastcgi_param   SCRIPT_FILENAME  ;
        fastcgi_pass    127.0.0.1:9000;
    }

    # deny access to apache .htaccess files
    location ~ /\.ht
    {
        deny all;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/local /etc/nginx/sites-enabled/local
sudo service nginx restart
