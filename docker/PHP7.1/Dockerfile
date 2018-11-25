FROM php:7.1-fpm

ARG USER_NAME
ARG USER_ID

RUN apt-get update && apt-get install -y \
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
    zip \
&& docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql bcmath xml xsl mbstring soap json zip intl \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd

RUN rm -rf /var/lib/apt/lists/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN curl -sL 'https://deb.nodesource.com/setup_10.x' | bash
RUN apt-get install --yes nodejs
RUN npm install -g grunt-cli
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
RUN echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' > /usr/local/etc/php/php.ini

RUN useradd -r -u $USER_ID $USER_NAME
USER $USER_NAME
