# Dotfiles

Here's a collection of all my dotfile configurations I use in my Linux installation. I use Fedora,
though I see no reason other distros shouldn't work with these. Feel free to copy what you need!

## Installation
1) Ensure that Git and GNU Stow are installed on your system
```
$ sudo dnf install git stow
```

2) First, clone this repository into your home directory using Git
```
$ git clone git@github.com/cubipod/dotfiles.git
$ cd dotfiles
```

3) Use GNU Stow to create the symlinks
```
$ stow .
```
