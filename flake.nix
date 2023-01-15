{
  # Resources:
  # https://nixos.wiki/wiki/Nix_vs._Linux_Standard_Base
  # https://nixos.wiki/wiki/Nix_package_manager
  # https://nix.dev/tutorials/nix-language
  # https://ryantm.github.io/nixpkgs/
  # https://nixos.org/manual/nix/stable/language/builtins.html
  # https://nixos.wiki/wiki/Flakes
  # https://serokell.io/blog/practical-nix-flakes
  # https://github.com/Misterio77/nix-config

  description = "My self-contained, Nix based config";

  # Extends the behavior of Nix
  nixConfig = {
    # TODO: change hardware-configuration.nix generation path to match respective host
  };

  inputs = {
    # Upstream nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  
    # Upstream hardware optimizations
    hardware.url = "github:nixos/nixos-hardware";
  
    # Upstream impermanence
    impermanence.url = "github:nix-community/impermanence";
  
    # Upstream sops
    sops-nix.url = "github:mic92/sops-nix";
  
    # Upstream home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # versioning of home-manager pkgs follows nix pkgs
    };

    # Upstream user repository & utils
    #nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";

    # Upstream dev env tools
    cachix.url = "github:cachix/cachix";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: 
  let
    inherit (self) inputs outputs;
    supportedSystems = [ "x86_64" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in
  rec {
    # Nix configuration entrypoint
    templates = import ./nix/templates;
    myconfig = ./.config;
    mycommon = ./nix/hosts/common;
    myusers = {};#import ./nix/hosts/users/names.nix;
    mylib = import ./nix/lib;
    myoverlays = forAllSystems (system:
      import ./nix/mypkgs/overlays { pkgs = nixpkgs.legacyPackages.${system}; }
    );
    mypkgs = forAllSystems (system:
      import ./nix/mypkgs/pkgs { pkgs = nixpkgs.legacyPackages.${system}; }
    );

    # NixOS confi is a module: https://nixos.org/manual/nixos/stable/index.html#sec-importing-modules
    nixosConfigurations = rec { # Hosts declaration. Poorly named, depends only on Nix, not NixOS
      Alpine = nixpkgs.lib.nixosSystem {
        special-args = { inherit inputs outputs }; # Pass flake in/outs to the system config
        modules = [ ./nix/hosts/Alpine ]; # Entrypoint for the system config
      };
      Fedora = nixpkgs.lib.nixosSystem {
        special-args = { inherit inputs outputs };
        modules = [ ./nix/hosts/Fedora ];
      };
      NixOS = nixpkgs.lib.nixosSystem {
        special-args = { inherit inputs outputs };
        modules = [ ./nix/hosts/NixOS ];
      };
      PostmarketOS = nixpkgs.lib.nixosSystem {
        special-args = { inherit inputs outputs };
        modules = [ ./nix/hosts/PostmarketOS ];
      };
  	};

    homeConfigurations = { # declarations for users configs
  	  ${myusers.alpine.u1.name} + "@Alpine" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux"; # a misnomer: legacyPackages simply accomodates flakes and non-flakes pkgs into one glob
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ${myusers.alpine.u1.path} ];
        };
  	  # Desktop
      ${myusers.nixos.u1.name} + "@NixOS" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ${myusers.nixos.u1.path} ];
      };
      # Phone
      ${myusers.postmarketos.u1.name} + "@PostmarketOS" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ${myusers.postmarketos.u1.path} ];
      };
    };
  };
}