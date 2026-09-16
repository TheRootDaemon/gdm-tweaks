{
  description = "Declarative GDM customizations for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-unit = {
      url = "github:nix-community/nix-unit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-unit,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.${system}.gdm-tweaks = import ./lib {
      inherit pkgs;
    };

    tests = import ./tests;

    checks.${system}.default =
      pkgs.runCommand "tests" {
        nativeBuildInputs = [
          nix-unit.packages.${system}.default
        ];
      } ''
        export HOME="$(realpath .)"

        nix-unit \
          --eval-store "$HOME" \
          --extra-experimental-features flakes \
          --override-input nixpkgs ${nixpkgs} \
          --flake ${self}#tests

        touch $out
      '';
  };
}
