# all opts: https://nixos.org/manual/nixos/unstable/options.html
{ lib, config, inputs, outputs, ... }:{
  imports = with ${mycommon} [
    /openrc.nix
    /ext4-partition.nix
    /pipewire.nix
    /kde.nix
    /wayland-kde.nix
    /sops.nix
  ] ++ (builtins.attrValues outputs.nixosModules);
  # autograb hardware specs: https://www.mankier.com/8/nixos-generate-config
  import = ./hardware-configuration.nix;

  # global pkgs and services
  environment = {
    persistence = {
      "/persist".directories = [ "/var/lib/systemd" "/var/log" "/srv" ];
    };
    enableAllTerminfo = true;
  };

  # TODO: check pam options
  security.pam

  networking = {
    networkmanager.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  allowUnfree = true;

  # also source direnv
  environment.systemPackages = with pkgs; [
    direnv
  ]

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  system.stateVersion = "22.11";
}