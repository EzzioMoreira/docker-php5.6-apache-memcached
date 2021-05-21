FROM php:5.6-apache

ENV TZ=America/Sao_Paulo
# Seta timezone.
RUN echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && echo date.timezone = $TZ > /usr/local/etc/php/conf.d/docker-php-ext-timezone.ini

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# ENV Apache
#ENV APACHE_DOCUMENT_ROOT /var/www/html/gestor
#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
#RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copia app 
#COPY ./config/php.ini /usr/local/etc/php/
#COPY index.php /var/www/html

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
    zlib1g-dev \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

# Configura Extensões 
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr

# Install Extensões
RUN docker-php-ext-install mbstring soap pdo pdo_odbc opcache  mysqli mysql pdo_mysql gd mcrypt zip imap 

# Habilita mod_rewrite Apache
RUN a2enmod rewrite ssl headers

# Install Extensões memcached 2.2
RUN CFLAGS="-fgnu89-inline" pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# Instala Memcache 3.0.8.
RUN CFLAGS="-fgnu89-inline" pecl install memcache-3.0.8 \
    && docker-php-ext-enable memcache

RUN chown -R www-data:www-data /var/www/html

# Cria volumes.
VOLUME ["/var/www/html","/var/log/"]

# Expõe portas
EXPOSE 80
EXPOSE 443
