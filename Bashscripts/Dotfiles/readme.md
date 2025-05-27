# Dotfiles Manager Script

This script automates the management of dotfiles by:

- Collecting user-specified configuration files from `$HOME`
- Copying them into a version-controlled `dotfiles_repo` directory
- Creating symbolic links from `$HOME` to the centralized repo

This approach allows you to maintain and sync your configuration across systems using Git.

---

## Features

- Automatically initializes a `dotfiles_repo` directory
- Collects predefined dotfiles (e.g., `.bashrc`, `.vimrc`, `.gitconfig`, etc.)
- Creates symbolic links from `$HOME` to the central repo
- Backs up existing config files before linking
- Supports easy restoration on new systems

---

## Usage

```
./dotfiles_manager.sh
```

The script will:

1. Create a ```~/dotfiles_repo``` directory if it doesn't exist

2. Copy selected dotfiles from your home directory

3. Backup any existing files

4. Create symbolic links in ```$HOME``` pointing to the repo

## Example
```
$HOME/.bashrc    →    ~/dotfiles_repo/.bashrc
$HOME/.vimrc     →    ~/dotfiles_repo/.vimrc
```
After running the script, all modifications can be made in the dotfiles_repo folder and committed to a Git repository for version control.

## Customization
Edit the dotfiles_manager.sh script to include any additional files you want to track:

```
DOTFILES=(
  ".bashrc"
  ".vimrc"
  ".gitconfig"
  ".tmux.conf"
  ...
)
```
## Benefits
- Centralized configuration management

- Version control via Git

- Easy backup and restore across environments

- Reduced setup time on new systems
