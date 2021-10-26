# Based on https://github.com/docker-library/drupal/blob/master/9.2/php8.0/apache-buster/Dockerfile
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.202.5/containers/php/.devcontainer/base.Dockerfile

ARG VARIANT="8.0-apache-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

# from https://www.drupal.org/docs/system-requirements/php-requirements
FROM php:8.0-apache-buster

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
	a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
	libfreetype6-dev \
	libjpeg-dev \
	libpng-dev \
	libpq-dev \
	libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
	--with-freetype \
	--with-jpeg=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
	gd \
	opcache \
	pdo_mysql \
	pdo_pgsql \
	zip \
	; \
	\
	# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
	| awk '/=>/ { print $3 }' \
	| sort -u \
	| xargs -r dpkg-query -S \
	| cut -d: -f1 \
	| sort -u \
	| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# Install Composer version 2
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Drush using Composer
ENV DRUSH_VERSION 8
RUN composer global require drush/drush:"$DRUSH_VERSION" --prefer-dist
ADD https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar /usr/bin/drush/
RUN chmod +x /usr/bin/drush/drush.phar

RUN apt-get update && apt-get install unzip
# RUN drush --version
