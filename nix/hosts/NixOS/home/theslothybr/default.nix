{
  description = "";

  inputs = {
    # text
  };

  outputs = {
    # text
    users.users.alice.extraGroups = [ "networkmanager" ];
  };
}