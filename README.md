# Dotfiles

Here's a collection of all my dotfile configurations I use in my Linux installation. I use Fedora,
though I see no reason other distros shouldn't work with these. Feel free to copy what you need!

## Programs
The programs these dotfiles are for can be installed like so
```
$ sudo dnf install i3 polybar alacritty
```
### What are these programs?
[Alacritty](https://github.com/alacritty/alacritty) is a terminal emulator

[i3](https://github.com/i3/i3) is a tiling window manager

[Polybar](https://github.com/polybar/polybar) is an information bar (ex: displaying the time)

## Installation
1) Ensure that Git and GNU Stow are installed on your system
```
$ sudo dnf install git stow
```

2) Clone this repository into your home directory using Git
```
$ cd ~/
$ git clone git@github.com/cubipod/dotfiles.git
$ cd dotfiles
```

3) Use GNU Stow to create the symlinks
```
$ stow .
```
