# Outline

- curent support for installing packages on manjaro (pacman and pamac(AUR) are used)
- my desktop-environment (DE) of choice is mate with i3
	- mate for standard tasks like multi-monitor-setups
	- i3 for tilling

# Variants

## ./install.sh -b

- installs the base-packages for use on the cli
- sets configs for the base-packages (like neovim, lf, tmux, ...)

## ./install.sh -i3

- install of the base-packages plus i3
- manual steps throught GUI required
	- open `dconf` to change used components of **mate**
		- `/org/mate/desktop/session/required-components/windowmanager`
			- change from `marco` to `i3`
		- `/org/mate/desktop/session/required-components-list`
			- remove `filemanager` from the array of the components
		- `/com/solus-project/brisk-menu/hot-key`
			- `<mod6>d` for Windows-Key+d to open the menu

# Future

- support for debian 11
	- check disto on start for the package-installation
