#!/bin/bash

# get absolute path to dotfiles folder
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# if no argument given, output helf and exit
if [[ ! $# -gt 0 ]]; then
	echo "use:"
	echo "install.sh (-a|--all)"
	echo " - installs package"
	echo " - installs symlinks to configs"
	echo "install.sh (-p|--packages)"
	echo " - installs packages"
	echo "install.sh (-c|--configs)"
	echo " - installs symlinks to configs"
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
			shift
			;;
		*)
			;;
	esac
done


if [[ ${action[packages]} = true ]]; then
	# packages from core/community
	sudo pacman -Syu htop ranger neovim termite
	# packages from AUR
	pamac install nerd-fonts-source-code-pro 
fi

if [[ ${action[configs]} = true ]]; then
	# nvim
	TARGET='.config/nvim/init.vim'
	if [[ ! -L $HOME/${TARGET} ]]; then
		if [[ -f $HOME/${TARGET} ]]; then
			mv $HOME/${TARGET} $HOME/${TARGET}_pre_dotfile
		fi
		ln -s ${BASEDIR}/${TARGET} $HOME/${TARGET}
		# additional steps
		if [[ ! -d $HOME/.config/nvim/bundle/Vundle.vim ]]; then
			git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
			nvim +PluginClean +qall
			nvim +PluginInstall +qall
		fi
	else
		echo "[already symlinked] ${TARGET}" 
	fi

	# bash
	TARGET='.bashrc'
	if [[ ! -L $HOME/${TARGET} ]]; then
		if [[ -f $HOME/${TARGET} ]]; then
			mv $HOME/${TARGET} $HOME/${TARGET}_pre_dotfile
		fi
		ln -s ${BASEDIR}/${TARGET} $HOME/${TARGET}
		# additional steps here
	else
		echo "[already symlinked] ${TARGET}" 
	fi

	#TODO
	# use function for repeating lines (54-58)
	# create assoziative list for after actions (like vundle) (60-64)
fi
