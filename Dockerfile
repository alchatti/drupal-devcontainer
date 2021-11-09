# Based on https://github.com/docker-library/drupal/blob/master/9.2/php8.0/apache-buster/Dockerfile
# For list of tags vsist https://mcr.microsoft.com/v2/vscode/devcontainers/php/tags/list

ARG VARIANT="8.0-apache-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

# from https://www.drupal.org/docs/system-requirements/php-requirements
# FROM php:${VARIANT}

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

# ENV Defailts fpr APACHE
ENV APACHE_DOCUMENT_ROOT "docroot"
ENV WORKSPACE_ROOT "/var/www/html"

# ENV based Apache Configurations
RUN sed -ri -e 's!/var/www/html!${WORKSPACE_ROOT}/${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

RUN apt-get update; \
	apt-get install -y unzip \
	default-mysql-client;

# Add Drush Launcher for Global and local Drush
ADD https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar /usr/bin/drush
RUN chmod ugo+rx /usr/bin/drush

# Drush Launcher global drush as fallback
ENV DRUSH_LAUNCHER_FALLBACK /opt/drush

# Install Drush 8.* globally for D6, D7, D8.3-
# for D8.4+ use Drupal Composer site project with Drush listed as a dependency
ADD https://github.com/drush-ops/drush/releases/download/8.4.8/drush.phar /opt/drush
RUN chmod ugo+rx /opt/drush

# Add Acquia Cli
ADD https://github.com/acquia/cli/releases/latest/download/acli.phar /usr/bin/acli
RUN chmod ugo+rx /usr/bin/acli

# RUN chown -R vscode:www-data /var/www

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Choice] DART SASS version none, 1.43.4
ARG DART_SASS_VERSION="none"
RUN if [ "${DART_SASS_VERSION}" != "none" ]; then \
	wget -P /opt/ https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz && \
	tar -C /opt/ -xzvf /opt/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz && \
	rm /opt/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz && \
	ln -s /opt/dart-sass/sass /usr/bin/sass; \
	fi;

