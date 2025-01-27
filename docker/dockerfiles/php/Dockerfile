FROM php:8.4.1-fpm AS php

WORKDIR /var/www/app

ARG user
ARG uid

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libc6 \
    zip \
    unzip \
    supervisor \
    htop \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    default-mysql-client

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

RUN pecl install redis

COPY --from=composer:2.8.5 /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

COPY ./docker/dockerfiles/php/config/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/dockerfiles/php/config/supervisord.conf /etc/supervisor/supervisord.conf

FROM php AS dev

COPY ./docker/dockerfiles/php/config/php-dev.ini /usr/local/etc/php/conf.d/php.ini

COPY . .

RUN chmod -R 775 ./storage ./bootstrap/cache

COPY ./docker/dockerfiles/php/config/entrypoint-dev.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]

USER $user
