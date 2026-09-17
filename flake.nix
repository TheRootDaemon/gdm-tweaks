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
    # packages provided by the flake
    packages.${system} = {
      default = import ./lib {inherit pkgs;};
      gdm-tweaks = self.packages.${system}.default;
      nix-unit = nix-unit.packages.${system}.default;
    };

    # checks for validating the flake
    checks.${system}.default = pkgs.stdenv.mkDerivation {
      name = "tests";
      phases = ["unpackPhase" "buildPhase"];
      src = self;
      nativeBuildInputs = [nix-unit.packages.${system}.default];
      buildPhase = ''
        nix-unit ${./tests/default.nix}
        touch $out
      '';
    };
  };
}
