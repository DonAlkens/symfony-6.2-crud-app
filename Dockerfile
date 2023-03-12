FROM php:8.1.2-fpm

# RUN apt-get update -y && apt-get install -y openssl zip unzip git
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# # Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer from dockerhub
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN docker-php-ext-install pdo_mysql mbstring

EXPOSE 8000

WORKDIR /app
COPY . /app

RUN composer install

# RUN useradd userToRunComposer
# USER userToRunComposer

RUN ["chmod", "+x", "docker-entrypoint.sh"]
ENTRYPOINT ["bash", "docker-entrypoint.sh"]
