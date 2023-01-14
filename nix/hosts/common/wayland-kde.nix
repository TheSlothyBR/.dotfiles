# https://nixos.org/manual/nixos/stable/index.html#sec-wayland
{
  services.xserver = {
    displayManager.sddm = {
      settings = {
        session = "plasma-wayland";
        # maybe needs nvidia specific settings
      };
    };
    # wayland may need pkgs.libsForQt514.plasma-wayland-protocols
  }
}