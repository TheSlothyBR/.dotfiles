# https://nix-community.github.io/home-manager/index.html#ch-usage
{ pkgs, outputs, ... }:{
  myusers.alpine = {
    u1 = {
      name = mylib.cleanParent ./.;
      path = ./.;
    };
  };
  users.mutableUsers = false;
  users.users.${myusers.alpine.u1.name} = {
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
    ];

    openssh.authorizedKeys.keys = [
      # TODO: copy keys here ""
    ];
    passwordFile = config.sops.secrets.${myusers.alpine.u1.name} + "-password".path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.${myusers.alpine.u1.name} + "-password" = {
    sopsFile = ${mycommon} + /secrets/secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.${myusers.alpine.u1.name} = import ./home.nix;
}