{
  # Resources:
  # https://nixos.wiki/wiki/Flakes
  # https://github.com/Misterio77/nix-config
  # https://serokell.io/blog/practical-nix-flakes

  description = "My self-contained, Nix based config";

  inputs = {
	# Upstream nixpkgs
	nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

	# Upstream impermanence
	impermanence.url = "github:nix-community/impermanence";

	# Upstream hardware optimizations
	hardware.url = "github:nixos/nixos-hardware";

	# Upstream home manager
	home-manager = {
	  url = "github:nix-community/home-manager";
	  inputs.nixpkgs.follows = "nixpkgs"; # versioning of home-manager pkgs follows nix pkgs
	}

	# Upstream user repository & utils
	nur.url = "github:nix-community/NUR";
	flake-utils.url = "github:numtide/flake-utils";

	# Upstream dev env tools
	cachix.url = "github:cachix/cachix";
	devenv.url = "github:cachix/devenv";
	# also source direnv from home-manager: https://github.com/nix-community/nix-direnv/tree/master/templates/flake
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: 
  let
 # TODO: revisit the declaration for better understanding
    inherit (nixpkgs.lib) ;# list needded functions
	inherit (builtins) ;# list needded functions
	inherit (self) outputs;
	supportedSystems = [ "x86_64" "aarch64-linux" ];
	forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in
  rec {
	# Nix configuration entrypoint
	# https://www.mankier.com/8/nixos-generate-config

    templates = import ./templates;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays;

	packages = forAllSystems (system:
	  import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; } # TODO: review the ./pkgs for proper pathing
	);
	devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { }; # TODO: same as above
    });

	nixosConfigurations = { # Hosts declaration. Poorly named, depends only on Nix, not NixOS
	  Alpine = {
	    special-args = { inherit inputs }; # Pass flake inputs to the config
		modules = [ ./nix/hosts/Alpine/flake.nix ]; # Entrypoint for the system config
	  };
	  Fedora = {
	    special-args = { inherit inputs };
		modules = [ ./nix/hosts/Fedora/flake.nix ];
	  };
	  NixOS = {
	    special-args = { inherit inputs };
		modules = [ ./nix/hosts/NixOS/flake.nix ];
	  };
	};

    homeConfigurations = { # declarations for users/host system configs
	  "theslothybr@Alpine" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux"; # a misnomer: legacyPackages simply accomodates flakes and non-flakes pkgs into one glob
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./hosts/Alpine/flake.nix ];
      };
	  # Desktop
      "theslothybr@NixOS" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./hosts/NixOS/flake.nix ];
	  };
	  # Phone
      "theslothybr@PostmarketOS" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./hosts/PostmarketOS/flake.nix ];
      };
	};
	# the othe top-level attr of flakes is nixConfig, which extends the behavior of Nix
  };
}