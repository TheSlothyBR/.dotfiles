# implementation of diff init systems:
# https://github.com/7c6f434c/7c6f434c-configurations/blob/master/init-less-system/generic/tools.nix#L373
# https://github.com/NixOS/nixpkgs/issues/126797#issuecomment-860284050
# https://discourse.nixos.org/t/how-to-start-a-daemon-properly-in-nixos/14019
 
# low level manipulation:
# https://nixos.wiki/wiki/Installing_from_Linux
# https://nixos.wiki/wiki/Bootloader
{
  # very experimental, most initrd opts dont work right now
  boot.initrd.systemd.enable = false;
}