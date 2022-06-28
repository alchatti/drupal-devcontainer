# Drupal Devcontainer

This project is created to provide a VS Code development container environment for Drupal utilizing the image from https://github.com/alchatti/drupal-devcontainer-image which is based on Microsoft PHP development container image.

## Usage

> If you are on Windows use WSL2 filesystem for optimal performance.

An example project is available at **WIP**

This project implements [pnpm](https://pnpm.io/), a Fast, disk space efficient package manager for NodeJS.
You will need to create an external docker volume using the following command:

```bash
docker volume create pnpm-store
```

Or comment out `external:true` under pnpm-store volumes item in `docker-compose.yml` using `#`.

```yml
pnpm-store:
  # external: true
```

## Overview

With Drupal your project folder structure should look similar to:

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

### - Option A: Submodule

Use it as a submodule of your Drupal project git repository. Inside the project directory run the following command.

```bash
git submodule add https://github.com/alchatti/devcontainer-drupal.git .devcontainer
```

Once cloned, you should have `.devcontainer` as a nested git repo. You can create your own branch and remote for .devcontainer.

Refer to <https://docs.github.com/en/get-started/getting-started-with-git/managing-remote-repositories> for more information.

### - Option B: Zip Archive

- Download as a zip file and extract the root of your project under `.devcontainer` directory.

## Build & Launch

From within VS Code <https://code.visualstudio.com/docs/remote/containers>.

Or using devcontainer-cli which allows you to launch commandline without the need to reopen vscode for relaunch:

```bash
# Build a new devcontainer instance
devcontainer build .
# Launch a devcontainer instance
devcontainer open .
```

For more information refer to <https://code.visualstudio.com/docs/remote/devcontainer-cli>.

## Configurations

Once setup is completed under `.devcontainer` directory you can find the following files:

- `config/mysql.cnf`: MySQL configuration file.
- `config/dev.setttings.php`: Devcontainer Drupal site configuration and environment based Database connection.

## Development settings `dev.setttings.php`

To use this file and limit it to development environment, you can use the following steps:

1. Copy the example file to your project directory under `.dev`

```bash
mkdir .dev && \
cp .devcontainer/.dev/example.dev.settings.php \
./.dev/dev.settings.php
```

2.Add the following code to the end of your site `settings.php` file.

```php
  if ( file_exists('/var/www/site-php/dev.settings.php')) {
    include '/var/www/site-php/dev.settings.php';
   }
```

3.docker-compose mappes the `.dev` directory to `/var/www/site-php/`

4.For optional `gitignore` copy the file under `.dev` to root of your project.

```bash
cp .devcontainer/.dev/example.gitignore  ./.gitignore
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

### Git Submodules

```bash
git clone --recurse-submodules $projectRepoUrl
```

### Config Sync folder location

It is recommended to change the default config sync folder location out of the docroot folder.

```bash
### In settings.php add the following line
$settings['config_sync_directory'] = '../config';
```

## Reference

- Docker Repo https://hub.docker.com/r/alchatti/drupal-devcontainer
- Image issues, details, source https://github.com/alchatti/drupal-devcontainer-image

## License

This repository is under an [MIT license](https://github.com/alchatti/devcontainer-drupal/blob/main/LICENSE) unless indicated otherwise.
