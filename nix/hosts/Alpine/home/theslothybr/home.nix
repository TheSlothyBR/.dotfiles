{ inputs, outputs, lib, pkgs, config, ... }:
let
  impermanence = inputs.impermanence.nixosModules.home-manager.impermanence;
in {
  imports = [
    impermanence
    ./apps/neovim.nix
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
    username = lib.mkDefault ${myusers.alpine.u1.name};
    homeDirectory = lib.mkDefault "/home/" + ${myusers.alpine.u1.name};
    stateVersion = lib.mkDefault "22.11";

    persistence = {
      "/persist/home/" + ${myusers.alpine.u1.name} = {
        directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
        ];
        allowOther = true;
      };
    };
  };
}