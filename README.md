The install-script in this dotfiles are meant for manjaro, so pacman and pamac should be available to install required packages.

I switched to a setup combining i3 with mate to have a full Desktop Environemt (DE) for handling
tasks like screen-hotplug, general settings and so on.

For using i3 inside of mate the following settings have to be done with dconf:

To change the used components **dconf** is used.
- `/org/mate/desktop/session/required-components/windowmanager`
	- change from `marco` to `i3`
- `/org/mate/desktop/session/required-components-list`
	- remove `filemanager` from the array of the components
- `/com/solus-project/brisk-menu/hot-key`
	- `<mod6>d` for Windows-Key+d to open the menu

```bash
usage:
install.sh (-a|--all)
 - installs packages
 - installs symlinks to configs
install.sh (-p|--packages)
 - installs packages
install.sh (-c|--configs)
 - installs symlinks to configs
install.sh (-cb|--configs-basic)
 - installs symlinks to the basic configs
 - like nvim, bash, elixir
```
