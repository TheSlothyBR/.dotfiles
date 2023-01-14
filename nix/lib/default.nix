{
  # recursive imports are not a problem: https://discourse.nixos.org/t/import-list-in-configuration-nix-vs-import-function/11372
  imports = [
    ./symlinks.nix;
    ./helpers.nix;
  ];
}