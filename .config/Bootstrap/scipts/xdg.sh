#!/usr/bin/env bash

xdg::set {

	std::info "Exporting XDG path"
# define system path
if ! grep -q XDG_CONFIG_HOME $HOME/.config/.bashrc; then
	cat << 'EOF' >> $HOME/.config/.bashrc
#------------------------------------------------------------------------------#
# default system paths
	export XDG_CONFIG_DIRS="/etc/xdg"
	export XDG_DATA_DIRS="/usr/local/share:/usr/share"
# default usr paths
	export XDG_CONFIG_HOME="$HOME/.config"
	export XDG_CACHE_HOME="$HOME/.cache"
	export XDG_DATA_HOME="$HOME/.local/share"
	export XDG_STATE_HOME="$HOME/.local/state"
EOF
fi

# create dirs file
if ! [[ -f $HOME/.config/user-dirs.dirs ]]
	touch $HOME/.config/user-dirs.dirs
	cat << 'EOF' > user-dirs.dirs
# default home directories
	XDG_DESKTOP_DIR="$HOME/desktop"
	XDG_DOCUMENTS_DIR="$HOME/documents"
	XDG_DOWNLOAD_DIR="$HOME/downloads"
	XDG_MUSIC_DIR="$HOME/music"
	XDG_PICTURES_DIR="$HOME/pictures"
	XDG_PUBLICSHARE_DIR="$HOME/public"
	XDG_TEMPLATES_DIR="$HOME/templates"
	XDG_VIDEOS_DIR="$HOME/videos"
# additional directories
	XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
EOF
fi
}