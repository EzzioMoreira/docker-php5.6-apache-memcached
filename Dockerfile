FROM php:5.6-apache

ENV TZ=America/Sao_Paulo
# Seta timezone.
RUN echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && echo date.timezone = $TZ > /usr/local/etc/php/conf.d/docker-php-ext-timezone.ini

RUN mkdir -p /etc/apache2/ssl_omni

# Configuração padrão php.ini and index.php.
COPY ./config/php.ini /usr/local/etc/php/
COPY ./config/conf.d/* /usr/local/etc/php/conf.d/

# Executa apt update, upgrade e install.
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends \
    libmemcached11 \
    libmemcachedutil2 \
    libmemcached-dev \
    libz-dev \
    build-essential \
    apache2-utils \
    libmagickwand-dev \
    imagemagick \
    libcurl4-openssl-dev \
    libssl-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    libmcrypt-dev \
    unixodbc-dev \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

# Configura extensão.
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr

# Instala extensões padrões.
RUN docker-php-ext-install mysqli mysql mbstring opcache pdo_mysql gd mcrypt zip imap soap pdo pdo_odbc

# Habilita headers apache.
RUN a2enmod rewrite ssl headers

# Instala Imagick.
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Instala Memcached 2.2.0.
RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# Instala Memcache 3.0.8.
RUN pecl install memcache-3.0.8 \
    && docker-php-ext-enable memcache
 
RUN chown -R www-data:www-data /var/www

# Cria volumes.
VOLUME ["/etc/apache2","/var/www/html","/var/log/apache2"]

# Expõe portas
EXPOSE 80
EXPOSE 443