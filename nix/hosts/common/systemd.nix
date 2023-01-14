# https://nixos.wiki/wiki/Systemd_Hardening
{
  # very experimental, most initrd opts dont work right now
  #boot.initrd.systemd.enable = true;
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
  };
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;
}