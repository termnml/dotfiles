# dotfiles

My dotfiles are designed to be used on Manjaro. The pkg-manager `pacman` is used for the manjaro-repos and `pamac` for AUR-repo.

(Support for apt is in the pipeline)

My desktop-environment of choice consists of the windowmanager **i3** in conjunction with the DE **mate**.

## Install

The installation includes the installation of required packages (with pacman and pamac (Manjaro)) with `packages_base` and `packages_desktop` in combination with setting symlinks into home (`~`) of the user (appending `_pre_dotfile` to already present configs before creating the links).

### ./install.sh -b

- installs the `packages_base` for system without a GUI
- sets `configs` for CLI-programs

### ./install.sh -i3

- install the `packages_base` and `packages_i3`
- **manual steps throught the GUI are required**
	- open `dconf` to change used components of **mate**
		- `/org/mate/desktop/session/required-components/windowmanager`
			- change from `marco` to `i3`
		- `/org/mate/desktop/session/required-components-list`
			- remove `filemanager` from the array of the components
		- `/com/solus-project/brisk-menu/hot-key`
			- `<mod6>d` for Windows-Key+d to open the menu

## Extras

Several folders in `.config` contain additional `README's` with Snippets and Screencaptures.

- [vim](.config/nvim/)

# Future

- support for debian 11
	- check disto on start for the package-installation
