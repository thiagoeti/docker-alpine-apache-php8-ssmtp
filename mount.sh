#!/bin/sh

# data
mkdir "/data"
mkdir "/data/www"

# log
mkdir "/data/log"
mkdir "/data/log/www"
mkdir "/data/log/apache"
mkdir "/data/log/www/app-php8-ssmtp"

# app
mkdir "/data/www/app-php8-ssmtp"
mkdir "/data/www/app-php8-ssmtp/log"

# drop
docker rmi -f "alpine-apache-php8-ssmtp"

# build
docker build --no-cache -t "alpine-apache-php8-ssmtp" "/data/container/alpine-apache-php8-ssmtp/."

# test
rm -rfv "/data/www/app-php8-ssmtp"
cp -rfv "/data/container/alpine-apache-php8-ssmtp/_app/" "/data/www/app-php8-ssmtp"

# drop
docker rm -f "app-php8-ssmtp"

# run -> app
docker run --name "app-php8-ssmtp" \
	-p 7004:80 \
	-v "/etc/hosts":"/etc/hosts" \
	-v "/data/log/apache/app-php8-ssmtp":"/var/log/apache2" \
	-v "/data/log/www/app-php8-ssmtp":"/data/log" \
	-v "/data/www/app-php8-ssmtp":"/data" \
	--restart=always \
	-d "alpine-apache-php8-ssmtp":"latest"

# attach
docker attach "app-php8-ssmtp"
docker exec -it "app-php8-ssmtp" "/bin/bash"

# start
docker start "app-php8-ssmtp"

# app

docker exec -d "app-php8-ssmtp" "/bin/bash" php -v

#
