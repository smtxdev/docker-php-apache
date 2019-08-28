# Do not change anything here except ARG. Real changes only in the main Dockerfile.
ARG PHP_VERSION=7.2
FROM php:${PHP_VERSION}-apache
ENV TZ "Europe/Berlin"
RUN apt-get update && apt-get install -qy \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        libicu-dev \
        msmtp \
        git \
        zip \
        curl \
        software-properties-common \
        unzip \
        build-essential \
        apache2-dev \
        gnupg \
        libzip-dev \
        graphicsmagick-imagemagick-compat \
        libmagickwand-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache && docker-php-ext-enable opcache
RUN docker-php-ext-install calendar
RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pcntl
RUN pecl install imagick
RUN docker-php-ext-enable imagick
RUN if [ $(echo "$PHP_VERSION" | tr -d '.' | head -c 2 ) -lt 70 ]; then docker-php-ext-install mysql; fi
RUN if [ $(echo "$PHP_VERSION" | tr -d '.' | head -c 2 ) -lt 70 ]; then docker-php-ext-install pdo; fi
RUN if [ $(echo "$PHP_VERSION" | tr -d '.' | head -c 2 ) -lt 70 ]; then docker-php-ext-install mbstring; fi
RUN if [ $(echo "$PHP_VERSION" | tr -d '.' | head -c 2 ) -lt 72 ]; then docker-php-ext-install mcrypt; fi
RUN mkdir -p /usr/local/opt/rpaf
ADD https://github.com/gnif/mod_rpaf/archive/stable.zip /usr/local/opt/rpaf
RUN cd /usr/local/opt/rpaf && unzip stable.zip
RUN cd /usr/local/opt/rpaf/mod_rpaf-stable && make && make install
ADD ./rpaf.load /etc/apache2/mods-available
ADD ./rpaf.conf /etc/apache2/mods-available
RUN a2enmod rewrite headers expires rpaf
ADD ./bashrc.sh /usr/local/bashrc.sh
RUN chmod +x /usr/local/bashrc.sh && echo "source /usr/local/bashrc.sh" >> /root/.bashrc
ADD ./php.ini /usr/local/etc/php/php.ini
ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
