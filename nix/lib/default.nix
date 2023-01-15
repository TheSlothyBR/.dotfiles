{
  # recursive imports are not a problem: https://discourse.nixos.org/t/import-list-in-configuration-nix-vs-import-function/11372
  # https://nixos.org/guides/nix-pills/functions-and-imports.html#idm140737320444992
  imports = [
    ./symlinks.nix;
    ./helpers.nix;
  ];
}