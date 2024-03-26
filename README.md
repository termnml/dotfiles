# current

- switched to Fedora on my private machines as I work more in the RHEL field now
	- my old setup with `i3` and `mate` became to custom
- now using [gnome-shell](https://github.com/GNOME/gnome-shell) with some extensions to get a tiling WM with a decent DE
 	- [forge](https://extensions.gnome.org/extension/4481/forge/) (tiling)
   	- [space-bar](https://extensions.gnome.org/extension/5090/space-bar/) (workspace indicator)
	- [AppIndicator](https://extensions.gnome.org/extension/615/appindicator-support/) (app-tray)
	- [Lock Keys](https://extensions.gnome.org/extension/36/lock-keys/) (virtual capslock indicator)

## fast-start (installing dotfiles)

- `update-dotfiles` is a bash-function in my `.bashrc` and downloads (and triggers refresh)
	- `.bashrc`
	- `.tmux.conf`
	- `.vimrc`
 - fast deployment of my dotfiles via:

```bash
wget --no-check-certificate -q -O ~/.bashrc https://raw.githubusercontent.com/termnml/dotfiles/main/.bashrc
. ~/.bashrc
update-dotfiles
```


# old

My dotfiles are designed to be used on Manjaro. The pkg-manager `pacman` is used for the manjaro-repos and `pamac` for AUR-repo.

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
