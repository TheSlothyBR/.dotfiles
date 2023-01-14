{ lib, config, ... }:{
  imports = [
    ./hardware-configuration.nix
    ../common/realtime-kernel.nix
    ../common/systemd.nix
    ../common/btrfs-partition.nix
    ../common/nidia.nix
    ../common/keyboard.nix

    ../common/pipewire.nix
    ../common/kde.nix
    ../common/wayland-kde.nix
    ../common/nushell.nix
    ../common/podman.nix
    ../common/ssh.nix
    ../common/sops.nix
  ] ++ (builtins.attrValues outputs.nixosModules);
  # global pkgs and services
  networking = {
    networkmanager.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/Libvirt
  virtualisation.libvirtd = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [ 
    virt-manager
    direnv
  ];

  system.stateVersion = "22.11";
}