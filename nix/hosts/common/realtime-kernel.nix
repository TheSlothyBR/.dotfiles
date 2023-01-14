# https://nixos.org/manual/nixos/stable/index.html#sec-kernel-config
{ 
  boot.kernel = {
    enable = true;
  };
  #boot.kernelModules = [ strings ];
  #boot.kernelPatches = { grab from pkgs.kernelPatches };

  # low latency audio: https://nixos.wiki/wiki/PipeWire
}