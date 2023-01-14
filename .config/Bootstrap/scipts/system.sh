#!/usr/bin/env bash

system::set {

	std::info "Exporting system path"

if ! grep -q root:/bin/bash /etc/passwd; then
	sed '\%root%s%/bin/bash%/usr/bin/nologin%' /etc/passwd
fi

if ! grep -q /bin/nu /etc/shells; then
	cat << 'EOF' >> /etc/shells
/bin/nu
/usr/bin/nu
EOF
fi

if ! grep -q EDITOR $HOME/.config/.bashrc; then
	cat << 'EOF' >> $HOME/.config/.bashrc
# change default editor
	export EDITOR="/bin/nvim"
EOF
fi

if ! grep -q USR_SHELL $HOME/.config/.bashrc; then
	cat << 'EOF' >> $HOME/.config/.bashrc
# change prefered shell
	export USR_SHELL="/bin/nu"
EOF
fi

if ! grep -q config.sh $HOME/.config/.bashrc; then
	cat << 'EOF' >> $HOME/.config/.bashrc
# declare nnn variables
	source $XDG_CONFIG_HOME/nnn/config.sh
EOF
fi

if ! grep -q SRC_HOME $HOME/.config/.bashrc; then
	cat << 'EOF' >> $HOME/.config/.bashrc
# additional directories
	export EDITOR="/usr/bin/nvim"
	export SRC_HOME="$HOME/src"
	export VM_SHARE="$HOME/VMshare"
	export VM_ALPINE="$VM_SHARE/alpine"
	export VM_ARCH="$VM_SHARE/arch"
EOF
fi

	# distrobox enter <container> -nw
	#distrobox create --image docker.io/library/alpine:latest --name alpine --home $HOME/VMshare/alpine
	#distrobox create --image docker.io/library/archlinux --name arch --home $HOME/VMshare/arch
}