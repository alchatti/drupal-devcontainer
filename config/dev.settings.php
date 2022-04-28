<?php

/**
 * @file
 * Local development override configuration feature.
 *
 *
 * To activate this file, copy the following code to the end of your
 * settings.php.
 * # if (file_exists($app_root . '/' . $site_path . '/settings/local.settings.php')
 * #     && file_exists('/var/www/dev.settings.php')) {
 * #   include $app_root . '/' . $site_path . '/settings/local.settings.php';
 * #  }
 *
 * Replace DB settings inside `/settings/local.settings.php` with
 * # require('/var/www/dev.settings.php');
 */

$db_name = $_ENV['MYSQL_DATABASE'];

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

$settings['trusted_host_patterns'] = [
  'localhost',
];

$base_url = 'http://localhost';

$options['uri'] = 'http://localhost';
