#!/bin/bash

# Dotfiles Auto Manager - Collect and symlink dotfiles

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles_repo"
BACKUP_DIR="$HOME/dotfiles_backup/$(date '+%Y%m%d_%H%M%S')"
LOG_FILE="$HOME/dotfiles_manager.log"

DOTFILES_LIST=(
    ".bashrc"
    ".vimrc"
    ".gitconfig"
    ".tmux.conf"
    ".profile"
    ".zshrc"
    ".config/nvim/init.vim"
    ".config/alacritty/alacritty.yml"
)

mkdir -p "$DOTFILES_DIR" "$BACKUP_DIR"
: > "$LOG_FILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

collect_and_link() {
    local original="$HOME/$1"
    local repo_copy="$DOTFILES_DIR/$1"
    local link_target="$HOME/$1"

    if [[ -e "$original" ]]; then
        log "Found $original"

        # Backup existing file
        mkdir -p "$(dirname "$BACKUP_DIR/$1")"
        mv "$original" "$BACKUP_DIR/$1"
        log "Backed up $original to $BACKUP_DIR/$1"

        # Copy file to dotfiles repo
        mkdir -p "$(dirname "$repo_copy")"
        cp -a "$BACKUP_DIR/$1" "$repo_copy"
        log "Copied to repo: $repo_copy"

        # Create symlink
        mkdir -p "$(dirname "$link_target")"
        ln -s "$repo_copy" "$link_target"
        log "Linked $repo_copy → $link_target"
    else
        log "Skipped missing file: $original"
    fi
}

log "Starting dotfiles auto-manager..."
for file in "${DOTFILES_LIST[@]}"; do
    collect_and_link "$file"
done
log "Dotfiles collection and linking complete."
