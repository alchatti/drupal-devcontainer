#!/bin/bash

PHP=8.1
NODE=17
SASS=1.50.0

docker build \
--build-arg VARIANT=$PHP-apache-bullseye \
--build-arg NODE_VERSION=$NODE \
--build-arg DART_SASS_VERSION=$SASS \
-t alchatti/drupal-devcontainer:$PHP-17-1.50.0 -t alchatti/drupal-devcontainer:latest .
