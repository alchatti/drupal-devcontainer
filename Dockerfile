# Based on https://github.com/docker-library/drupal/blob/master/9.2/php8.0/apache-bullseye/Dockerfile file
# Uses mcr.microsoft.com/vscode/devcontainers/php as base image
# For list of tags vsist https://mcr.microsoft.com/v2/vscode/devcontainers/php/tags/list

ARG VARIANT
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

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

# Init Script
COPY ./.build/init.sh /init.sh
RUN chmod o+xr /init.sh

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

# Acquia BLT Launcher
ADD https://github.com/acquia/blt-launcher/releases/latest/download/blt.phar /usr/bin/blt
RUN chmod ugo+rx /usr/bin/blt

# Oh My Posh
ADD https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 /usr/local/bin/oh-my-posh
ADD https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip /opt/themes.zip

RUN chmod +x /usr/local/bin/oh-my-posh && \
  unzip /opt/themes.zip -d /opt/.poshthemes && \
  rm /opt/themes.zip && \
  chmod o+r /opt/.poshthemes/*.json

# PowerShell
ADD https://github.com/PowerShell/PowerShell/releases/download/v7.2.3/powershell-lts_7.2.3-1.deb_amd64.deb /tmp/powershell.deb
RUN dpkg -i /tmp/powershell.deb && \
  apt-get install -f -y \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

RUN pwsh -c "Install-Module \"posh-git\",\"PSReadLine\",\"Terminal-Icons\",\"posh-sshell\" -scope AllUsers -Force"

COPY ./.build/powershell_profile.ps1 /opt/microsoft/powershell/7-lts/profile.ps1
RUN chmod o+r /opt/microsoft/powershell/7-lts/profile.ps1

USER vscode

RUN echo "$(oh-my-posh init zsh)" >> ~/.zshrc && \
  sed -ri -e 's!POSH_THEME="/home/vscode/.*.omp.json"!POSH_THEME="/opt/.poshthemes/$POSH_THEME_ENVIRONMENT.omp.json"!g' ~/.zshrc && \
  echo "exec \$SHELL -l"  >> ~/.bashrc

# Drupal Coder and phpcs Requirements
# version is specified due to bug https://www.drupal.org/project/coder/issues/3262291
RUN composer global require drupal/coder 8.3.13
RUN ~/.composer/vendor/bin/phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer
RUN sudo ln -s ~/.composer/vendor/bin/phpcs /usr/bin/phpcs

RUN mkdir ~/.pnpm-store

USER root

# Drupal filesystem
RUN mkdir /mnt/files
RUN chown vscode:vscode /mnt/files

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ] &&  [ "${NODE_VERSION}" != "" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1 && npm -g i pnpm"; fi

# [Choice] DART SASS version none, 1.43.4
ARG DART_SASS_VERSION="none"
RUN if [ "${DART_SASS_VERSION}" != "none" ] && [ "${DART_SASS_VERSION}" != "" ]; then \
  wget -P /opt/ https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz && \
  tar -C /opt/ -xzvf /opt/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz && \
  rm /opt/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz && \
  ln -s /opt/dart-sass/sass /usr/bin/sass; \
  fi;

RUN rm -r /tmp/*
