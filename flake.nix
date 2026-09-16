{
  description = "Declarative GDM customizations for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.${system}.gdm-tweaks = import ./lib {
      inherit pkgs;
    };
  };
}
