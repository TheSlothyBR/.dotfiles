# https://nixos.wiki/wiki/Keyboard_Layout_Customization
{
  services.xserver = { 
    layout = "br";
    xkbVariant = "abnt2"; # or "nodeadkeys"
    xkbModel = "pc105";
    xkbOptions = "";
  };
}