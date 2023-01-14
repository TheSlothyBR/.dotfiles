# https://github.com/pjones/plasma-manager
# https://nixos.wiki/wiki/KDE
{
  services.xserver = {
    enable = true; # https://github.com/NixOS/nixpkgs/issues/94799
    displayManager.sddm = {
      enable = true;
      #theme = "";
    };
    desktopManager.plasma5 = { 
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        print-manager
      ];
    };
  };
}