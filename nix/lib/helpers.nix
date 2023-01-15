{ config, lib, ... }:{
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  # if res is hashed, re split at "-" and grab last
  cleanParent = path: pkgs.lib.lists.last (pkgs.lib.strings.splitString "/" path);
}