# Dotfiles Management with GNU Stow

This repository contains configuration files (dotfiles) for macOS, organized by application and managed using [GNU Stow](https://www.gnu.org/software/stow/). Stow makes it easy to symlink config files from this repo into your home directory, keeping your setup reproducible and maintainable.

## Directory Structure

Each application's config files are stored in their own subdirectory, mirroring their expected locations:

```
configs/
├── zsh/
│   └── .zshrc
├── starship/
│   └── .config/
│       └── starship.toml
└── ghostty/
    └── .config/
        └── ghostty/
            └── config
```

## Setup Steps

### 1. Copy Your Existing Config Files

If you already have config files in your home directory, copy them into the appropriate subdirectories:

```sh
mkdir -p ~/mac-setup/configs/zsh
mkdir -p ~/mac-setup/configs/starship/.config
mkdir -p ~/mac-setup/configs/ghostty/.config/ghostty
mkdir -p ~/mac-setup/configs/zed/.config

cp ~/.zshrc ~/mac-setup/configs/zsh/.zshrc
cp ~/.config/starship.toml ~/mac-setup/configs/starship/.config/starship.toml
cp ~/.config/ghostty/config ~/mac-setup/configs/ghostty/.config/ghostty/config
cp -R ~/.config/zed ~/mac-setup/configs/zed/.config/
```

### 2. Backup and Remove Originals

Before using Stow, backup and remove the original files from your home directory to avoid conflicts:

```sh
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/starship.toml ~/.config/starship.toml.backup
mv ~/.config/ghostty/config ~/.config/ghostty_config.backup
mv ~/.config/zed ~/.config/zed.backup
```

### 3. Install GNU Stow

On macOS, install Stow via Homebrew:

```sh
brew install stow
```

### 4. Symlink Configs with Stow

Change to your configs directory and run Stow for each application, targeting your home directory:

```sh
cd ~/mac-setup/configs
stow -t ~ zsh
stow -t ~ starship
stow -t ~ ghostty
stow -t ~ zed
```

### 5. Verify Symlinks

Check that the symlinks were created correctly:

```sh
ls -l ~/.zshrc
ls -l ~/.config/starship.toml
ls -l ~/.config/ghostty/config
ls -l ~/.config | grep zed
ls -l ~/.config/zed
```

You should see that each file is now a symlink pointing to the corresponding file in this repo.

## Notes

- To add more configs, create a new subdirectory for the app and repeat the steps above.
- To remove symlinks, use `stow -D <folder>` (e.g., `stow -D zsh`).

## Troubleshooting

- If Stow creates files in the wrong directory, check your current working directory and use the `-t` flag to specify the target.
- If Stow refuses to create symlinks, ensure the original files are removed or backed up.
