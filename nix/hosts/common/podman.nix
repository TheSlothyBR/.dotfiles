# https://nixos.wiki/wiki/Podman
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}