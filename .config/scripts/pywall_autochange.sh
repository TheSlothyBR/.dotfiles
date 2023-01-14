#!/usr/bin/env bash

export wallpaper_path = <~/onedrive/wallpapers>
shopt -s nullglob

wallpapers = (
	"$wallpaper_path"/*.jpg
	"$wallpaper_path"/*.jpeg
	"$wallpaper_path"/*.png
	"$wallpaper_path"/*.svg
)

wallpaper_size = ${#wallpapers[*]}

# random between 0-9
function r_number = { 
	local r_index = 0 
	until [ $r_index -le $wallpaper_size ]
	do
		r_index = $(( RANDOM % 10 ))
	done
	echo "$r_index"
}

result = "$(r_number)"

plasma-apply-wallpaperimage "${wallpapers[$result]}"
wal -q -i "${wallpapers[$result]}"

#index = 0
#while [$index -le $wallpaper_size ]
#do
#	# ~/.config/plasma-org.kde.plasma.desktop-appletsrc
#	plasma-apply-wallpaperimage "${wallpapers[$index]}"
#	wal -q -i "${wallpapers[$index]}"
#	
#	if [ $(($index+1)) -eq $wallpaper_size ]
#	then
#		index = 0
#	else
#		index = $(($index+1))
#	fi
#	sleep 30m
#done