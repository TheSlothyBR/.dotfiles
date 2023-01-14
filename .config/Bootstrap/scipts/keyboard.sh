#!/usr/bin/env bash

keyboard::set() {

    std::info "Setting keyboard layout"
    # See more at https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg
    localectl set-x11-keymap br pc105 nodeadkeys

    setxkbmap -model pc105 -layout br -variant nodeadkeys -config <xkb_path>
}
