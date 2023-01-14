# https://nixos.wiki/wiki/Overlays
{ builtins, outputs, ... }:{
  nixpkgs.overlays = builtins.attrValues outputs.myoverlays;
}