cd /var/www/html
composer create-project --no-install drupal/recommended-project:^9.0.0 .
sed -i'.original' 's/web\//docroot\//g' composer.json && rm composer.json.original
composer require drush/drush:^10.2 drupal/mysql56 --no-update
composer update
