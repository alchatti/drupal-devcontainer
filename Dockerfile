# Based on https://github.com/docker-library/drupal/blob/master/9.2/php8.0/apache-buster/Dockerfile
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.202.5/containers/php/.devcontainer/base.Dockerfile

ARG VARIANT="8.0-apache-Buster"
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

# from https://www.drupal.org/docs/system-requirements/php-requirements
FROM php:8.0-apache-buster

# START - Based on https://github.com/docker-library/drupal/blob/master/9.2/php8.0/apache-buster/Dockerfile
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

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

#END

RUN apt-get update; \
	apt-get install -y unzip \
	default-mysql-client;

# Add Drush to path
ENV PATH "$PATH:/var/www/html/vendor/drush/drush"

# Add Acquia Cli
ADD https://github.com/acquia/cli/releases/latest/download/acli.phar /usr/bin/acli
RUN chmod ugo+rx /usr/bin/acli

# Set www-data to have UID 1000
RUN usermod -u 1000 www-data;

RUN chown -R www-data:www-data /var/www
