# https://nixos.wiki/wiki/Nvidia
{
  services.xserver = {
    videoDrivers = [ "nvidia"];
  };
}