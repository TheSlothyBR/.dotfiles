# https://rycee.gitlab.io/home-manager/options.html#opt-programs.nushell.enable
# https://news.ycombinator.com/item?id=30773907
{ outputs, ... }:{
 home-manager.programs.nushell = {
   enable = true;
   configFile.source = "../../../.config/nushell/config.nu";
   envFile.source = "../../../.config/nushell/env.nu";
 };
}