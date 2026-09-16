{
  pkgs,
  gnomeShell ? pkgs.gnome-shell,
  background ? null,
}:
pkgs.stdenv.mkDerivation {
  pname = "gdm-tweaks";
  version = "0.1.0";

  nativeBuildInputs = [
    pkgs.glib.dev
  ];

  buildCommand = import ./build.nix {
    inherit pkgs gnomeShell background;
  };
}
