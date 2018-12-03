#!/bin/bash

apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    nano \
    gnupg \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    unzip \
    zip

docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql bcmath xml xsl mbstring soap json zip intl

docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install -j$(nproc) gd

curl -sL 'https://deb.nodesource.com/setup_10.x' | bash
apt-get install --yes nodejs
npm install -g grunt-cli

rm -rf /var/lib/apt/lists/*

curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

export PATH=$PATH:/usr/local/go/bin
source /etc/environment && export PATH

go get github.com/mailhog/mhsendmail
cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"
