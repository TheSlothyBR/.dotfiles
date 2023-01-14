#!/usr/bin/env bash

source ./apps.sh

#declare -n repos=repos
#declare -n appimages=appimages
#declare -n rpms=rpms
#declare -n flatpaks=flatpaks
#declare -n overwrites=overwrites
#declare -n uninstalls=uninstalls

setapps::repo() {
	
	std::info "Setting up repos"
	
	local dir=/etc/yum.repos.d/
	for repo in "${repos[@]}"; do
		wget -P $dir $repo
	done
	
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

	#flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

	rpm-ostree install -A https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

	#wget -P $HOME/Applications  https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.rpm
}

setapps::set() {

    std::info "Beginning installation"
	
	rpm-ostree refresh-md
	
	std::info "Downloading appimages"
	local dir=$HOME/Applications
	for appimage in "$appimages[*]"; do
		wget -P $dir $appimage
		chmod +x $dir/$(echo "$appimage" | rev | cut -d'/' -f 1 | rev)
		#conditional wget to include -O pcloud.appimage
		#then sudo ./pcloud.appimage --install
	done

	std::info "Uninstalling base packages"
	for overwrite in "$overwrites[*]"; do
		rpm-ostree override remove $overwrite
	done

	std::info "Installing flatpaks"
	for flatpak in "$flatpaks[*]"; do
		flatpak install $flatpak
	done
	
	std::info "Installing cli"
	for rpm in "${rpms[*]}"; do
		rpm-ostree install --allow-inactive $rpm
	done
}