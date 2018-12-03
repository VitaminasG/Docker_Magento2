ARG VERSION

FROM php:$VERSION

ARG PHP_VERSION
ARG USER_NAME
ARG USER_ID


RUN echo "adf"$PHP_VERSION

COPY ./install.sh ./install.sh
RUN bash ./install.sh $PHP_VERSION

RUN useradd -r -u $USER_ID -ms /bin/bash $USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME

RUN echo 'cd /var/www/html' >> ~/.bashrc
