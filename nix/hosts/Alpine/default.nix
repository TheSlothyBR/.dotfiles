# all opts: https://nixos.org/manual/nixos/unstable/options.html
{ lib, config, inputs, outputs, ... }:{
  imports = [
    # autograb hardware specs: https://www.mankier.com/8/nixos-generate-config
    ./hardware-configuration.nix
    ../common/openrc.nix
    ../common/ext4-partition.nix

    # find func like with ../common [ ... ]
    ../common/pipewire.nix
    ../common/kde.nix
    ../common/wayland-kde.nix
    ../common/sops.nix
  ] ++ (builtins.attrValues outputs.nixosModules);
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

  nixpkgs.config.allowUnfree = true;

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