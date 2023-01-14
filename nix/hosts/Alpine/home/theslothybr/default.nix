# https://nix-community.github.io/home-manager/index.html#ch-usage
{ pkgs, outputs, ... }:
let
  # TODO: check if good implementation
  getUser = lib.lists.last (lib.strings.splitString "/" (builtins.unsafeGetAttrPos "x" { x = 1; }).file);
in
{
  users.mutableUsers = false;
  users.users.${getUser} = {
    isNormalUser = true;
    shell = home-manager.programs.nushell;
    # TODO: check if this import works
    extraGroups = mylib.ifTheyExist [
      "wheel"
      "video"
      "audio"
      "network"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
      # TODO: copy keys here ""
    ];
    passwordFile = config.sops.secrets.misterio-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.theslothybr-password = {
    sopsFile = ../../../common/secrets/secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.${getUser} = import ./home.nix;
}