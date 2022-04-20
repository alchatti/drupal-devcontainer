<?php

/**
 * @file
 * Local development override configuration feature.
 *
 * To activate this file, copy the following code to the end of your settings.php
 ** if (file_exists('/var/www/settings.local.php')) { require('/var/www/settings.local.php'); }
 */
$base_url = 'http://localhost';
$options['uri'] = 'http://localhost';
$databases['default']['default'] = array(
  'database' => $_ENV['MYSQL_DATABASE'],
  'username' => $_ENV['MYSQL_USER'],
  'password' => $_ENV['MYSQL_PASSWORD'],
  'prefix' => '',
  'host' => 'db',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
