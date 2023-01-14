# https://nixos.wiki/wiki/GNOME
{
  services = {
    xserver = {
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
    };
  };
}