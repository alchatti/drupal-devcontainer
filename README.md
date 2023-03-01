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

- `.dev/example.dev.setttings.php`: Devcontainer Drupal site configuration and environment based Database connection.
- `.dev/example.drush.yml`: Drush configuration file.
- `.dev/example.gitignore`: Gitignore file.
- `.dev/example.launch.json`: VS Code launch configuration for XDebug.
- `.dev/example.mysql.cnf`: MySQL configuration file.

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop)
- [VS Code](https://code.visualstudio.com/)
- [VS Code Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

### Setup a new project

1.Create a new project directory `my-drupal-site` and change to it.

```bash
mkdir my-drupal-site && cd my-drupal-site
```

2.Initialize the `git` in the directory

```bash
git init
```

3.Add this repo as a submodule as `.devcontainer`

```bash
git submodule add https://github.com/alchatti/drupal-devcontainer.git .devcontainer
```

4.Create `docroot`, `.dev` directories.

```bash
mkdir docroot && mkdir .dev
```

5.If doesn't exist create `.vscode` directory for PHP debugging.

```bash
mkdir .vscode
```

6.Copy `example.*` files to your project for customizations.

```bash
cp .devcontainer/.dev/example.dev.settings.php ./.dev/dev.settings.php && \
cp .devcontainer/.dev/example.drush.yml ./.dev/drush.yml && \
cp .devcontainer/.dev/example.gitignore ./.gitignore && \
cp .devcontainer/.dev/example.launch.json ./.vscode/launch.json && \
cp .devcontainer/.dev/example.mysql.cnf ./.dev/mysql.cnf
```

7.Build the devcontainer (one time only)

```bash
devcontainer build .
```

| This version of the devcontainer cli is installed using vscode through quick open command.

For more information on devcontainer refer to <https://code.visualstudio.com/docs/remote/devcontainer-cli>.

### Start the devcontainer

8.To start the devcontainer from commandline you can always use

```bash
devcontainer open .
```

## Drupal first time setup

Insied the devcontainer `/var/www/html`

1.Install Drupal using `init.sh` script

```bash
init.sh
```

2.In browser http://localhost/ and follow the Drupal setup wizard.
  - you can go for `Demo: Umami Food Magazine (Experimental)` profile to test the site or `Standard` for empty site.
  - **Set up database**
      -  **Database type** -  MySQL, MariaDB, Percona Server, or equivalent
      -  **Database name** - db
      -  **Database username** - drupal
      -  **Database password** - drupalPASS
      -  **Advanced options > Host** - database
  -  Once site installed, complete the wizard to setup admin user an the time zone.  


3.Add the following code to the end of your site `docroot/sites/default/settings.php` file or follow the recommended _Drupal conmfiguration_ section below.

```php
if (file_exists('/var/www/site-dev/dev.settings.php')) {
  include '/var/www/site-dev/dev.settings.php';
}
```

### Recommended Drupal configuration

- Generate a new salt file outside of docroot.

```bash
openssl rand -base64 64 > $WR/.drupal-salt
```

- Append the following to `docroot/sites/default/settings.php`

```php
// Move Config sync folder to outside of Apache public folder
$settings['config_sync_directory'] = '../config';
// Use the generated salt outside of Apache public folder
$settings['hash_salt'] = file_get_contents('../.drupal-salt');
// Use `dev.settings.php` when it exists, docker will mount path when devcontainer
if (file_exists('/var/www/site-dev/dev.settings.php')) {
  include '/var/www/site-dev/dev.settings.php';
}
```

- To login without password `docroot` 

```sh
cd docroot
drush uli 0
```

## Quality of life

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

### Sharing Git credentials with your container

To use your credential helper and SSH keys within the devcontainer instance use the following guide <https://code.visualstudio.com/docs/remote/containers#_sharing-git-credentials-with-your-container>.

If you are using WSL2 you need to configure that first before using it in the devcontainer.

## Reference

- Docker Repo https://hub.docker.com/r/alchatti/drupal-devcontainer
- Image issues, details, source [alchatti/drupal-devcontainer-image](https://github.com/alchatti/drupal-devcontainer-image)
- Sample project [alchatti/drupal-devcontainer-sample-project](https://github.com/alchatti/drupal-devcontainer-sample-project)

## License

This repository is under an [MIT license](https://github.com/alchatti/devcontainer-drupal/blob/main/LICENSE) unless indicated otherwise.
