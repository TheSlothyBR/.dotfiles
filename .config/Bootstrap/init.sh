#!/usr/bin/env bash

P = $HOME/.config/Bootstrap/scripts

# preload
scripts = (
	setapps.sh
	dirs.sh
	keyboard.sh
	visual.sh
	shell.sh
	system.sh
	xdg.sh
)

for script in "${scripts[@]}"; do
	source $P/$script
done

# define run
main() {
	
	#xdg::set
	
	#system::set
	
	#dirs::make
	
	#dirs::links
	
	#keyboard::set
	
#if [[ $APPS =~ ^[Yy]$ ]]; then
	#setapps::repo
	
	#setapps::set
#else
	#return 0
#fi
}

# accidental start prevention
safeguard() {

# require sudo
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

	#read -p "Do you wish install apps (y/n)?" -n 1 -r APPS

	echo "The following operation will ovewrite your system configuration"
	read -p "Do you wish to proceed (y/n)?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
# run
	main()
	echo " "
	echo "Operation finished! Reboot the system to apply"
	echo " "
	exit 0
else
	echo " "
	echo "Operation aborted, nothing was changed"
	echo " "
	exit 1
fi
}

safeguard()