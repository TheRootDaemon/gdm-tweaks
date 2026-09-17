let
  fixturePkgs = {
    "adwaita-icon-theme" = {};
    "bibata-cursors" = {};
    "papirus-icon-theme" = {};
  };

  themes = builtins.attrNames fixturePkgs;
  icons = import ../config/icons.nix {pkgs = fixturePkgs;};
in
  {
    # isValidIconTheme
    testIsValidIconTheme_DoesNotExist = {
      expr = icons.isValidIconTheme "does-not-exist";
      expected = false;
    };

    testIsValidIconTheme_EmptyString = {
      expr = icons.isValidIconTheme "";
      expected = false;
    };

    testIsValidIconTheme_NotAString = {
      expr = icons.isValidIconTheme 42;
      expected = false;
    };

    testIsValidIconTheme_Null = {
      expr = icons.isValidIconTheme null;
      expected = false;
    };
  }
  # isValidIconTheme_Exists
  // builtins.listToAttrs (
    map (
      p: {
        name = "testIsValidIconTheme_${p}";
        value = {
          expr = icons.isValidIconTheme p;
          expected = true;
        };
      }
    )
    themes
  )
