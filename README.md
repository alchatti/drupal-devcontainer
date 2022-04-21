# Dev Container for Drupal

This project is created to provide a simple and quick configurable development container for Drupal.

The image uses <https://mcr.microsoft.com/v2/vscode/devcontainers/php/tags/list> as base image with includes the following:

- [Xdebug](https://xdebug.org/)
- Zsh

In addition to that the following tools with drupal requirements:

- [X] [Composer](https://getcomposer.org/)
- [X] [Drush](https://www.drush.org/latest/) & [Drush launcher](https://github.com/drush-ops/drush-launcher) with Drush 8 installed as global fallback for Drupal 7 & 8.
- [X] [Drupal Coder](https://www.drupal.org/project/coder)

- [X] [Acquia cli](https://docs.acquia.com/acquia-cli/)
- [ ] [Acquia BLT](https://docs.acquia.com/blt/) WIP

- [X] [Node.js](https://nodejs.org)
- [X] [Dart Sass](https://github.com/sass/dart-sass)

This image also contains the following terminal enhancements:

- [PowerShell](https://github.com/PowerShell/PowerShell)
  - [posh-git](https://github.com/dahlbyk/posh-git): integrates Git and provides tab completion
  - [PSReadLine](https://github.com/PowerShell/PSReadLine)
  - [Terminal-Icons](https://github.com/devblackops/Terminal-Icons): use `dir` to display icons in the terminal
  - [posh-sshell](https://github.com/dahlbyk/posh-sshell): provides utilities for working with SSH connections

- [Oh My Posh](https://ohmyposh.dev/) for Zsh & PowerShell

## Quality of life

### Development container CLI

To launch a devcontainer instance from command line instead of using VS Code. Allows you to use the following commands:

```bash
# Build a new devcontainer instance
devcontainer build .
# Launch a devcontainer instance
devcontainer open .
```

Refer to <https://code.visualstudio.com/docs/remote/devcontainer-cli> for more information.

### Sharing Git credentials with your container

To use your credential helper and SSH keys with the devcontainer instance

Refer to <https://code.visualstudio.com/docs/remote/containers#_sharing-git-credentials-with-your-container> for more information.

## Usage

> If you are on Windows use WSL2 filesystem for optimal performance.

### Setup

Once setup is completed your project directory should look similar to:

```html
📂 Project-Name
 ├── 📂.devcontainer
 ├── 📂.git
 ├── 📄.gitignore
 ├── 📄.gitmodules
 ├── 📂.vscode
 ├── 📄composer.json
 ├── 📄composer.lock
 ├── 📂docroot
 └── 📂vendor
```

#### - Option A: Submodule

- This project can be used as a submodule inside the primary project directory.

```bash
git submodule add https://github.com/alchatti/devcontainer-drupal.git .devcontainer
```

Once cloned you can browser to `.devcontainer` directory and add your own upstream or replace origin remote to keep and store your changes.

Refer to <https://docs.github.com/en/get-started/getting-started-with-git/managing-remote-repositories> for more information.

#### - Option B: Zip Archive

- Download as a zip file and extract it to the root of your project under `.devcontainer` directory.

### Build & Launch

The devcontainer can be intialized by running the following command:

```bash
# Launch a devcontainer instance
devcontainer open .
```

Or from within VS Code <https://code.visualstudio.com/docs/remote/containers>.

## Configuration

Once setup is completed under `.devcontainer` directory you can find the following files:

- `config/apache/000-default.conf` & `config/apache/default-ssl.conf`: Apache configuration files.
- `config/mysql.cnf`: MySQL configuration file.
- `config/php.ini`: PHP configuration file including Xdebug.
- `config/settings.local.php`: Additional Drupal site configuration uses environment variables for Database connection. Refer to the file for more usage details.

### Change default shell

In `devcontainer.json` you can change the default shell to use **Zsh**.

```json
# Change default shell to Zsh
"terminal.integrated.defaultProfile.linux": "zsh",
```

### Change oh-my-posh theme

In `devcontainer.json` you can change the default shell to use **Zsh**.

```json
"remoteEnv": {
  "SHELL": "/bin/zsh",
  /* Change the following value https://ohmyposh.dev/docs/themes*/
  "POSH_THEME_ENVIRONMENT": "blue-owl",
 },
```

## License

This repository is under an [MIT license](https://github.com/alchatti/devcontainer-drupal/blob/main/LICENSE) unless indicated otherwise.
