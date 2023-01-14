#!/usr/bin/env bash

dirs::make {
	mkdir -p $HOME/VMshare $HOME/VMshare/alpine $HOME/VMshare/arch
	mkdir $HOME/src
	mkdir $HOME/onedrive
}

dirs::links {

	std::info "Setting softlinks"

#softlinks (shortcuts in windows)
# $HOME/ files
	# bash redirect
	ln -sf $HOME/.config/.bashrc $HOME/.bashrc
	ln -sf $HOME/.config/.bash_profile $HOME/.bash_profile
	# dotfolder redirect
	ln -sf $HOME/.config/.homevar $HOME/.var
	# mods redirect 
	ln -sf $HOME/onedrive/Mods/MO2setup/ $HOME/VMshare/arch/MO2
	
# /bin/ files

# /usr/ files
	# sddm themes redirect
	ln -sf $HOME/.config/.external/homeusr/themes /usr/share/sddm/themes

# /etc/ files
	# sddm config redirect
	ln -sf $HOME/.config/.external/homeetc/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf

	#std::info "Setting hardlinks"
#hardlinks (2 files will point to same data on drive, acts as backup)
}