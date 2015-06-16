#! /bin/sh

setup_vim(){
	git clone https://github.com/willm/vimrc.git
	ln -s vimrc/.vimrc ~/.vimrc
	mkdir -p ~/.vim/autoload ~/.vimbundle
	curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
}

setup_bash(){
	git clone https://github.com/willm/bash-setup.git
	ln -s bash-setup/.bash_aliases ~/.bash_aliases
}

setup_git(){
	git config --global color.ui true
	git config --global user.name "Will Munn"
	git config --global user.email "willmunn@hotmail.com"
	git config --global core.editor vim
	git config --global help.autocorrect 1
	git config --global core.autocrlf false
}

install_node(){
	sudo apt-get -y -q install nodejs
}

install_mono(){
	sudo apt-get install -y -q --force-yes mono-complete
}

add_repositories(){
	#hal needed for drm flash support
	sudo apt-add-repository ppa:mjblenner/ppa-hal
	echo "deb http://debian.meebey.net/experimental/mono /" >> /etc/apt/sources.list
	sudo apt-add-repository -y ppa:chris-lea/node.js
	sudo apt-get update
}

packages=(vim-gtk git git-gui guake clementine hal hal-info flashplugin-nonfree python-software-properties python g++ make curl python-pygments)

add_repositories
sudo apt-get remove -y -q rhythmbox thunderbird sudo remove unity-lens-shopping
for package in "${packages[@]}"; do
	sudo apt-get install -y -q "${package}" 
done
setup_vim
setup_bash
setup_git
install_node
install_mono
#enable encrypted dvd playback
sudo /usr/share/doc/libdvdread4/install-css.sh
