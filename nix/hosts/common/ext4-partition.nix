# https://nixos.org/manual/nixos/stable/index.html#ch-file-systems
# this implementations uses systemd, tho
{
  boot.initrd.supportedFilesystems = [ "ext4" ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "ext4";
      options = [ "subvol=root" "compress=zstd" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "ext4";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "ext4";
      options = [ "subvol=persist" "compress=zstd" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "ext4";
      options = [ "subvol=swap" "noatime" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 2048;
  }];
}