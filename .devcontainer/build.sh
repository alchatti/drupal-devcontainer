print_usage() {
  printf "\nUsage: -p phpVer -s sassVer -n nodeJSVer\n\nIf no version is provided the latest will be used\n\n"
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

if [ -z "$PHP" ]; then PHP=8.1-apache-bullseye; echo "No version setting PHP to default > $PHP";fi
if [ -z "$NODE" ]; then NODE=$(curl -s https://api.github.com/repos/nodejs/node/releases/latest | grep "tag_name.*" | cut -d ":" -f 2 | cut -d "\"" -f 2 | sed 's/v//g'); echo "No version provided setting NODE to latest > $NODE";fi
if [ -z "$SASS" ]; then SASS=$(curl -s https://api.github.com/repos/sass/dart-sass/releases/latest | grep "tag_name.*" | cut -d ":" -f 2 | cut -d "\"" -f 2); echo "No version provided setting SASS to latest > $SASS";fi

printf "\nBuilding image with \n - PHP $PHP \n - NodeJs $NODE \n - dart-sass $SASS \n\n"

docker build \
--build-arg VARIANT=$PHP \
--build-arg NODE_VERSION=$NODE \
--build-arg DART_SASS_VERSION=$SASS \
-t alchatti/drupal-devcontainer:p$PHP-n$NODE-s$SASS -t alchatti/drupal-devcontainer:latest .
