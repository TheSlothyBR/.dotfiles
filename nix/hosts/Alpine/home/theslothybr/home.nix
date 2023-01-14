{ inputs, lib, pkgs, config, outputs, ... }:
let
  # TODO: check if good implementation
  getUser = lib.lists.last (lib.strings.splitString "/" (builtins.unsafeGetAttrPos "x" { x = 1; }).file);
in{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    # TODO: figure out how to handle pkgs with settings in .config
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "${getUser}";
    homeDirectory = lib.mkDefault "/home/${getUser}";
    stateVersion = lib.mkDefault "22.11";

    persistence = {
      "/persist/home/${getUser}" = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
        ];
        allowOther = true;
      };
    };
  };
}