#!/bin/bash

# get absolute path to dotfiles folder
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# if no argument given, output help and exit
if [[ ! $# -gt 0 ]]; then
	echo "use:"
	echo "install.sh (-a|--all)"
	echo " - installs packages"
	echo " - installs symlinks to configs"
	echo "install.sh (-p|--packages)"
	echo " - installs packages"
	echo "install.sh (-c|--configs)"
	echo " - installs symlinks to all configs"
	echo "install.sh (-cb|--configs-basic)"
	echo " - installs symlinks to the basic configs"
	echo " - like nvim, bash, elixir"
	echo "install.sh (-am|--all-mate)"
	echo " - installs packages for mate+i3 setup"
	echo " - adds configuration basic and new like alacritty"
	exit 0
fi

# -A declares a associative list
declare -A action

# check what is to do and set flags
while test $# -gt 0; do
	case "$1" in
		-a|--all)
			action[packages]=true
			action[configs]=true
			shift
			;;
		-p|--packages)
			action[packages]=true
			shift
			;;
		-c|--configs)
			action[configs]=true
			action[configs_basic]=true
			shift
			;;
		-cb|--configs-basic)
			action[configs_basic]=true
			shift
			;;
		-ci3|--configs-i3)
			action[configs_i3]=true
			shift
			;;
		-am|--all-mate)
			action[packages_mate]=true
			action[configs_basic]=true
			action[configs_mate]=true
			action[configs_i3]=true
			shift
			;;
		*)
			;;
	esac
done


if [[ ${action[packages]} = true ]]; then
	# packages from core/community
	sudo pacman -Syu htop ranger neovim termite bind
	# packages from AUR
	pamac install nerd-fonts-source-code-pro mimeo xdg-utils-mimeo
fi

if [[ ${action[packages_mate]} = true ]]; then
	# packages from core/community
	sudo pacman -Syu htop ranger neovim alacritty xdotool zensu i3-wm wireshark-qt
	# packages from AUR
	pamac install nerd-fonts-source-code-pro
fi

SET_SYMLINK () {
	# get parentdir of file
	PARENT_DIR="$(dirname $HOME/$1)"
	# returns if symlink was created and action_after should be called
	if [[ ! -L $HOME/$1 ]]; then
		# create parent-dir if not present
		if [[ ! -d ${PARENT_DIR} ]]; then
			mkdir -p ${PARENT_DIR}
		fi
		# check if file already exists and backup
		if [[ -f $HOME/$1 ]]; then
			mv $HOME/$1 $HOME/$1_pre_dotfile
		fi
		ln -s ${BASEDIR}/$1 $HOME/$1
		echo "symlink_created"
	fi
}

if [[ ${action[configs]} = true ]]; then

	# mimetypes (mimeo replace default xdg-open)
	TARGET='.config/mimeapps.list'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# Xresources
	TARGET='.Xresources'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
		xrdb ~/.Xresources
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# termite
	TARGET='.config/termite/config'
	if [[ ! -d ~/.config/termite ]]; then
		mkdir ~/.config/termite
	fi
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

fi


if [[ ${action[configs_i3]} = true ]]; then
	# i3
	TARGET='.config/i3/config'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
		i3-msg restart
	else
		echo "[already symlinked] ${TARGET}"
	fi
fi

if [[ ${action[configs_basic]} = true ]]; then
	#ranger
	TARGET='.config/ranger/rc.conf'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi
	TARGET='.config/ranger/scope.sh'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# nvim
	TARGET='.config/nvim/init.vim'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
		if [[ ! -d $HOME/.config/nvim/bundle/Vundle.vim ]]; then
			git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
			nvim +PluginInstall +qall
		fi
	else
		echo "[already symlinked] ${TARGET}"
	fi
	TARGET='.local/share/applications/nvim.desktop'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# bash
	TARGET='.bashrc'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# IEX/Elixir
	TARGET='.iex.exs'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# alacritty
	TARGET='.config/alacritty/alacritty.yml'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

fi
