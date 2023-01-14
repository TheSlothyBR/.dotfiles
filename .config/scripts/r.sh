#!/usr/bin/env bash

DIR=${DIR:-$HOME/.var/app}
CMD=${CMD:-flatpak run}

launch_app() {
	find "${DIR}" -mindepth 1 -maxdepth 1 -type d -iname "*$1*" \
	-printf '%f\n' | xargs $CMD
}

launch_app "${1}"