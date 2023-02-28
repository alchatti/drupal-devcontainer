# Drupal Devcontainer

This project is created to provide a VS Code development container environment for Drupal utilizing the image from [alchatti/drupal-devcontainer-image](https://github.com/alchatti/drupal-devcontainer-image) which is based on Microsoft PHP development container image.

## Usage

> If you are on Windows use WSL2 filesystem for optimal performance.

An example project is available at [alchatti/drupal-devcontainer-sample-project](https://github.com/alchatti/drupal-devcontainer-sample-project)

For devcontainer to work, your Drupal project folder structure should look similar to:

> `docroot` is the public folder where your Drupal site is located. This is based on Acquia Cloud's project structure. Check [Change environment variables & shell themes](#change-environment-variables--shell-themes-env-variables)

```text
📂 My-Project
├── 📂.devcontainer
├── 📂.git
├── 📂.vscode
├── 📂 docroot
├── 📂 dump
├── 📂 vendor
├── 📄.editorconfig
├── 📄.gitignore
├── 📄.gitmodules
├── 📄 composer.json
└── 📄 composer.lock
```

## Setup a new project

1. Create a new project directory `my-drupal-site` and change to it.

```bash
mkdir my-drupal-site && cd my-drupal-site
```

2. Intialize the `git` in the directory

```bash
git init
```

3. Add this repo as a submodule under the folder `.devcontainer`

```bash
git submodule add https://github.com/alchatti/devcontainer-drupal.git .devcontainer
```

4. Make an empty `docroot` folder

```bash
mkdir docroot
```

5. Build & launch the devcontainer project

```sh
devcontainer build .
```

```sh
devcontainer open .
```

For more information on devcontainer refer to <https://code.visualstudio.com/docs/remote/devcontainer-cli>.

## Configurations

Once setup is completed under `.devcontainer` directory you can find the following files:

- `.dev/example.dev.setttings.php`: Devcontainer Drupal site configuration and environment based Database connection.
- `.dev/example.drush.yml`: Drush configuration file.
- `.dev/example.gitignore`: Gitignore file.
- `.dev/example.launch.json`: VS Code launch configuration for XDebug.
- `.dev/example.mysql.cnf`: MySQL configuration file.

## Development settings `dev.setttings.php`

To use this file and limit it to development environment, you can use the following steps:

1. Copy the example file to your project directory under `.dev`.

```bash
mkdir .dev && \
cp .devcontainer/.dev/example.dev.settings.php \
./.dev/dev.settings.php
```

2.Add the following code to the end of your site `settings.php` file.

```php
if (file_exists('/var/www/site-dev/dev.settings.php')) {
  include '/var/www/site-dev/dev.settings.php';
}
```

3.docker-compose mapes the `.dev` directory to `/var/www/site-php/`

4.For optional `gitignore` copy the file under `.dev` to root of your project.

```bash
cp .devcontainer/.dev/example.gitignore  ./.gitignore
```

5.For XDebug with VS Code, copy `launch.json` to `.vscode` folder.

```bash
cp .devcontainer/.vscode/launch.json ./.vscode/launch.json
```

### Change default shell

In `devcontainer.json` you can change the default shell to use **zsh**.

```json
"terminal.integrated.defaultProfile.linux": "zsh",
```

### Change environment variables & shell themes

In `devcontainer.json` you can change the default shell & theme by updating the `remoteEnv` property as follow:

- **SHELL** : changes shell, you can use `/bin/fish` or `/bin/zsh`.
- **POSH_THEME_ENVIRONMENT** to change the shell theme, check [Oh My Posh themes](https://ohmyposh.dev/docs/themes) for options.
- **APACHE_DOCUMENT_ROOT** to change the apache app root from `docroot`, `web`, `public` or anything else.

```json
"remoteEnv": {
  "SHELL": "/bin/zsh",
  "POSH_THEME_ENVIRONMENT": "blue-owl",
  "APACHE_DOCUMENT_ROOT": "web"
 },
```

## Quality of life

### Sharing Git credentials with your container

To use your credential helper and SSH keys within the devcontainer instance use the following guide <https://code.visualstudio.com/docs/remote/containers#_sharing-git-credentials-with-your-container>.

If you are using WSL2 you need to configure that first before using it in the devcontainer.

### Config Sync folder location

It is recommended to change the default config sync folder location out of the docroot folder.

```bash
### In settings.php add the following line
$settings['config_sync_directory'] = '../config';
```

### Salt for Drupal 10

In Drupal 10, the `settings.php` file has a new `settings['hash_salt']` property. You can generate a random string using the following command:

```bash
openssl rand -base64 64 > $WR/.drupal-salt
```

Then add the following line to your `settings.php` file:

```php
$settings['hash_salt'] = file_get_contents('../.drupal-salt');
```

### The end of settings.php file

```php
$settings['config_sync_directory'] = '../config';
$settings['hash_salt'] = file_get_contents('../.drupal-salt');
if (file_exists('/var/www/site-dev/dev.settings.php')) {
  include '/var/www/site-dev/dev.settings.php';
}
```

## Reference

- Docker Repo https://hub.docker.com/r/alchatti/drupal-devcontainer
- Image issues, details, source [alchatti/drupal-devcontainer-image](https://github.com/alchatti/drupal-devcontainer-image)
- Sample project [alchatti/drupal-devcontainer-sample-project](https://github.com/alchatti/drupal-devcontainer-sample-project)

## License

This repository is under an [MIT license](https://github.com/alchatti/devcontainer-drupal/blob/main/LICENSE) unless indicated otherwise.
