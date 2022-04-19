#!/bin/bash


print_usage() {
  printf "\nUsage: -p phpVer -s sassVer -n nodeJSVer\n\nIf no version is provided the latest will be used\n\n# For list of tags vsist https://mcr.microsoft.com/v2/vscode/devcontainers/php/tags/list\n\n"
}

while getopts p:s:n: flag;
do
    case "${flag}" in
        p) PHP=${OPTARG};;
        n) NODE=${OPTARG};;
        s) SASS=${OPTARG};;
		*) print_usage
       	   exit 1 ;;
    esac
done

if [ -z "$PHP" ]
then
  PHP=("8.1-apache-bullseye" "7.4-apache-bullseye")
  echo "No version setting PHP to defaults"
else
  PHP=($PHP);
fi;

if [ -z "$NODE" ]; then NODE=$(curl -s https://api.github.com/repos/nodejs/node/releases/latest | grep "tag_name.*" | cut -d ":" -f 2 | cut -d "\"" -f 2 | sed 's/v//g'); echo "No version provided setting NODE to latest > $NODE";fi
if [ -z "$SASS" ]; then SASS=$(curl -s https://api.github.com/repos/sass/dart-sass/releases/latest | grep "tag_name.*" | cut -d ":" -f 2 | cut -d "\"" -f 2); echo "No version provided setting SASS to latest > $SASS";fi


for phpver in ${PHP[@]}
do
  printf "\nBuilding image with \n - PHP $phpver \n - NodeJs $NODE \n - dart-sass $SASS \n\n"
  docker build \
  --build-arg VARIANT=$phpver \
  --build-arg NODE_VERSION=$NODE \
  --build-arg DART_SASS_VERSION=$SASS \
  -t alchatti/drupal-devcontainer:p$phpver-n$NODE-s$SASS -t alchatti/drupal-devcontainer:$phpver-latest .
done
