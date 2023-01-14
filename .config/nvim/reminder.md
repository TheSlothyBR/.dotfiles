- nixpkgs: https://search.nixos.org/packages
- nix quick start: https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/getting-started.html
- upgrade nix-env: https://nixos.org/manual/nix/stable/command-ref/nix-env.html#operation---upgrade
- replit nix overlay: https://github.com/replit/nixpkgs-replit
- configure .replit: https://docs.replit.com/programming-ide/configuring-repl

.replit
run = ["nvim"]

[nix]
channel = "stable-22_11"

replit.nix
{ pkgs }: {
    deps = [
        pkgs.neovim
        pkgs.vscode
    ];
}

nixpkgs/config.nix
{
  allowUnfree = true;
}