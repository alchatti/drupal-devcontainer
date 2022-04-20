# devontainer-drupal
Dev Container for Drupal


## Commands

### Creating a new Drupal 9 website Acquia

```bash
composer create-project --no-install drupal/recommended-project:^9.0.0 .
sed -i'.original' 's/web\//docroot\//g' composer.json && rm composer.json.original
composer require drush/drush:^10.2 drupal/mysql56 --no-update
composer update
```
