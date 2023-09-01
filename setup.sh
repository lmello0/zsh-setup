#!/bin/bash

ZSH_PKG_NAME="zsh"

if dpkg -l | grep -q "^ii.*$ZSH_PKG_NAME"; then
	echo "$ZSH_PKG_NAME is already installed"
else
	echo "$ZSH_PKG_NAME is not installed"

	sudo apt update -y
	
	sudo apt upgrade -y

	sudo apt install zsh

	sudo chsh -s $(which zsh)

	echo "Installing ZSH"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	echo "Downloading zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	echo "Downloading zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	echo "Downloading powerlevel10k"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	
	echo "Installing plugins and theme"
	ZSH_PLUGINS=$(cat .zshrc | grep "^plugins" | sed 's/plugins=//g; s/[()]//g')

	NEW_PLUGINS=("zsh-syntax-highlighting" "zsh-autosuggestions")

	UPDATED_PLUGINS="plugins=(${ZSH_PLUGINS} ${NEW_PLUGINS[*]})"
	
	sed "/^plugins=(/c\\$UPDATED_PLUGINS" > ~/.zshrc

	sed "/^ZSH_THEME=/c\\ZSH_THEME=powerlevel10k/powerlevel10k" > ~/.zshrc
fi
