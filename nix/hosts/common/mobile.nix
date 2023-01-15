# https://nixos.wiki/wiki/PinePhone
{config, ... }:{
  xserver.desktopManager.phosh = {
    enable = true;
    # TODO: check if this eval is correct, it might conflit with name resolution
    user = ${config.users.users.user.name};
    group = ${config.users.groups.group};
    # for better compatibility with x11 applications
    phocConfig.xwayland = "immediate";
  };
}