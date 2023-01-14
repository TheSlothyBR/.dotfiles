# https://nixos.wiki/wiki/PipeWire
{
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}