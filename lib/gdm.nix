{
  pkgs,
  gnomeShell ? pkgs.gnome-shell,
  accentColor ? null,
  background ? null,
}: let
  accentConfig = import ../config/accents.nix;

  # valid presets and hex colors passthrough,
  # `config.resolveAccent` throws errors for invalid values
  accentCSS =
    if accentColor == null
    then null
    else let
      resolved = accentConfig.resolveAccent accentColor;
    in
      if resolved.type == "color"
      then ":root { -st-accent-color: ${resolved.value}; }"
      else null;
in
  pkgs.stdenv.mkDerivation {
    pname = "gdm-tweaks";
    version = "0.2.0";

    nativeBuildInputs = [
      pkgs.glib.dev
    ];

    buildCommand = import ./build.nix {
      inherit pkgs gnomeShell accentCSS background;
    };
  }
