# https://rycee.gitlab.io/home-manager/options.html#opt-programs.nushell.enable
# https://news.ycombinator.com/item?id=30773907
{ outputs, ... }:{
 home-manager.programs.nushell = {
   enable = true;
   configFile.source = ${myconfig} + "/nushell/config.nu";
   envFile.source = ${myconfig} + "/nushell/env.nu";
 };
}