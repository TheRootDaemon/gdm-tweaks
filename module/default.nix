{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.displayManager.gdm-tweaks;

  accentConfig = import ../config/accents.nix;
  cursorConfig = import ../config/cursor.nix;
  iconConfig = import ../config/icons.nix;

  resolvedAccent =
    if cfg.accentColor == null
    then null
    else accentConfig.resolveAccent cfg.accentColor;

  resolvedCursor =
    if cfg.cursor == null
    then null
    else cursorConfig.resolveCursor cfg.cursor;

  resolvedIcons =
    if cfg.icons == null
    then null
    else iconConfig.resolveIcons cfg.icons;

  gdmTweaks = import ../lib {
    inherit pkgs;
    background = cfg.background;
    accentColor =
      if resolvedAccent == null
      then null
      else if resolvedAccent.type == "color"
      then resolvedAccent.value
      else null;
  };

  needsGdmTweaks = cfg.background != null || (resolvedAccent != null && resolvedAccent.type == "color");

  interfaceSettings =
    {}
    // lib.optionalAttrs (resolvedAccent != null && resolvedAccent.type == "preset") {
      "accent-color" = resolvedAccent.value;
    }
    // lib.optionalAttrs (cfg.cursor != null && resolvedCursor.name != null) {
      "cursor-size" = lib.gvariant.mkUint32 resolvedCursor.size;
      "cursor-theme" = resolvedCursor.name;
    }
    // lib.optionalAttrs (cfg.icons != null && resolvedIcons.name != null) {
      "icon-theme" = resolvedIcons.name;
    };
in {
  options.services.displayManager.gdm-tweaks = {
    enable = lib.mkEnableOption "gdm tweaks";

    accentColor = {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Accent color or the preset to use for GDM.";
    };

    background = {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Background image to use for the GDM login screen.";
    };

    cursor = {
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          name = {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Cursor theme name to use for GDM.";
          };

          size = {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = "Cursor size to use for GDM.";
          };

          theme = {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Package providing the cursor theme for GDM.";
          };
        };
      });
      default = null;
      description = "Cursor configuration for GDM.";
    };

    icons = {
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          name = {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Icon theme name to use for GDM.";
          };

          theme = {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Package providing the icon theme for GDM.";
          };
        };
      });
      default = null;
      description = "Icon configuration for GDM.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.displayManager.gdm.enable;
        message = "gdm-tweaks requires services.displayManager.gdm.enable to be true.";
      }
    ];

    services.displayManager.gdm.extraPackages = lib.mkAfter (
      lib.optionals (resolvedCursor != null && resolvedCursor.theme != null) [
        resolvedCursor.theme
      ]
      ++ lib.optionals (resolvedIcons != null && resolvedIcons.theme != null) [
        resolvedIcons.theme
      ]
    );

    programs.dconf.enable.gdm.databases = lib.mkAfter [
      {
        settings."org/gnome/desktop/interface" = interfaceSettings;
      }
    ];

    environment.etc."gdm/env.d/95-gdm-tweaks.env" = lib.mkIf needsGdmTweaks {
      text = ''
        GNOME_SHELL_DATADIR=${gdmTweaks}/share/gnome-shell
      '';
    };
  };
}
