#!/bin/bash
####
## Author: Felix Marx <termnml@gmail.com>
####
# get absolute path to dotfiles folder
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# if no argument given, output help and exit
if [[ ! $# -gt 0 ]]; then
		echo
		echo "use:"
		echo "install.sh (-b|--base)"
		echo " - packages_base"
		echo " - configs"
		echo "install.sh (-d|--desktop)"
		echo " - packages_base"
		echo " - packages_desktop"
		echo " - configs"
		echo " - configs_desktop"
		echo
	exit 0
fi

# -A declares a associative list
declare -A action

# check what is to do and set flags
while test $# -gt 0; do
	case "$1" in
		-d|--desktop)
			action[packages_base]=true
			action[packages_desktop]=true
			action[configs]=true
			action[configs_desktop]=true
			shift
			;;
		-b|--base)
			action[packages_base]=true
			action[configs]=true
			shift
			;;
		-h|--help|*)
			echo
      echo "use:"
			echo "install.sh (-b|--base)"
      echo " - packages_base"
      echo " - configs"
      echo "install.sh (-d|--desktop)"
      echo " - packages_base"
      echo " - packages_desktop"
      echo " - configs"
      echo " - configs_desktop"
			echo
	esac
done

if [[ ${action[packages_base]} = true ]]; then
	# packages from core/community
	sudo pacman -Syu --needed htop ranger neovim bash-completion bind
	# packages from AUR
	pamac install lf
fi

if [[ ${action[packages_desktop]} = true ]]; then
	# packages from core/community
	sudo pacman -Syu --needed alacritty xdotool xclip zensu i3-wm wireshark-qt
	# packages from AUR
	pamac install nerd-fonts-source-code-pro mimeo xdg-utils-mimeo
fi

logit () {
	# set color
	echo ""
	echo -e "\e[32;41m[PASS]\e[0m"
	echo -e "\n\e[36;40m[symlink]\e[0;30;1m=\e[40;32;1m[PASS]\e[0m \e[1m[~/.bashrc] \e[32mcorrect symlink \e[0m\e[1m-> [~/dotfiles/.bashrc]\e[0m\n"
	# unset color
	echo ""
}

SET_SYMLINK () {
	# get parentdir of file
	PARENT_DIR="$(dirname $HOME/$1)"
	# returns if symlink was created and action_after should be called
	if [[ ! -L $HOME/$1 ]]; then
		# create parent-dir if not present
		if [[ ! -d ${PARENT_DIR} ]]; then
			mkdir -p ${PARENT_DIR}
		else
			logit "[PASS]:${PARENT_DIR}"
		fi
		# check if file already exists and backup
		if [[ -f $HOME/$1 ]]; then
			mv $HOME/$1 $HOME/$1_pre_dotfile
		fi
		ln -s ${BASEDIR}/$1 $HOME/$1
		echo "symlink_created"
	fi
}

if [[ ${action[configs_desktop]} = true ]]; then
	# i3
	TARGET='.config/i3/config'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
		i3-msg restart
	else
		echo "[already symlinked] ${TARGET}"
	fi

	# picom (compton replacement)
	TARGET='.config/picom.conf'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

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
fi

if [[ ${action[configs]} = true ]]; then
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

	# tmux
	TARGET='.tmux.conf'
	if [[ "$(SET_SYMLINK ${TARGET})" == "symlink_created" ]]; then
		echo "[new symlink] ${TARGET}"
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}"
	fi

fi
