<?php

// phpcs:ignoreFile

/**
 * @file
 * Local development override configuration feature.
 *
 *
 * To activate this file, copy the following code to the end of your
 * settings.php.
 *
 * # $settings['config_sync_directory'] = '../config';
 * # $settings['hash_salt'] = file_get_contents('../salt.cnf');
 * #
 * # if (file_exists('/var/www/site-dev/dev.settings.php')) {
 * #  include '/var/www/site-dev/dev.settings.php';
 * # }
 */

// PHP
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);
$conf['error_level'] = 2; // Show all messages on your screen
error_reporting(1); // Have PHP complain about absolutely everything.

$db_name = $_ENV['MYSQL_DATABASE'];

if (!isset($databases)) {
  $databases = [];
}

$databases['default']['default'] = [
  'database' => $_ENV['MYSQL_DATABASE'],
  'username' => $_ENV['MYSQL_USER'],
  'password' => $_ENV['MYSQL_PASSWORD'],
  'prefix' => '',
  'host' => 'database',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
  'autoload' => 'core/modules/mysql/src/Driver/Database/mysql/',
  'init_commands' => [
    'isolation_level' => 'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED',
  ],
];

$settings['trusted_host_patterns'] = [
  '^localhost$',
];

/**
 * Assertions.
 *
 * The Drupal project primarily uses runtime assertions to enforce the
 * expectations of the API by failing when incorrect calls are made by code
 * under development.
 *
 * @see http://php.net/assert
 * @see https://www.drupal.org/node/2492225
 *
 * It is strongly recommended that you set zend.assertions=1 in the PHP.ini file
 * (It cannot be changed from .htaccess or runtime) on development machines and
 * to 0 or -1 in production.
 *
 * @see https://wiki.php.net/rfc/expectations
 */
assert_options(ASSERT_ACTIVE, TRUE);
assert_options(ASSERT_EXCEPTION, TRUE);

/**
 * Show all error messages, with backtrace information.
 *
 * In case the error level could not be fetched from the database, as for
 * example the database connection failed, we rely only on this value.
 */
$config['system.logging']['error_level'] = 'verbose';

/**
 * Disable CSS and JS aggregation.
 */
$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

/**
 * Skip file system permissions hardening.
 *
 * The system module will periodically check the permissions of your site's
 * site directory to ensure that it is not writable by the website user. For
 * sites that are managed with a version control system, this can cause problems
 * when files in that directory such as settings.php are updated, because the
 * user pulling in the changes won't have permissions to modify files in the
 * directory.
 */
$settings['skip_permissions_hardening'] = TRUE;

/**
 * Exclude modules from configuration synchronization.
 *
 * On config export sync, no config or dependent config of any excluded module
 * is exported. On config import sync, any config of any installed excluded
 * module is ignored. In the exported configuration, it will be as if the
 * excluded module had never been installed. When syncing configuration, if an
 * excluded module is already installed, it will not be uninstalled by the
 * configuration synchronization, and dependent configuration will remain
 * intact. This affects only configuration synchronization; single import and
 * export of configuration are not affected.
 *
 * Drupal does not validate or sanity check the list of excluded modules. For
 * instance, it is your own responsibility to never exclude required modules,
 * because it would mean that the exported configuration can not be imported
 * anymore.
 *
 * This is an advanced feature and using it means opting out of some of the
 * guarantees the configuration synchronization provides. It is not recommended
 * to use this feature with modules that affect Drupal in a major way such as
 * the language or field module.
 */
$settings['config_exclude_modules'] = ['devel', 'stage_file_proxy'];