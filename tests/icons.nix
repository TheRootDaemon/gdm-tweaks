let
  fixturePkgs = {
    "adwaita-icon-theme" = {};
    "papirus" = {};
    "macOS" = {};
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

    # isValidIconThemeName
    testIsValidIconThemeName_Valid = {
      expr = icons.isValidIconThemeName "exists";
      expected = true;
    };

    testIsValidIconThemeName_Null = {
      expr = icons.isValidIconThemeName null;
      expected = true;
    };

    testIsValidIconThemeName_EmptyString = {
      expr = icons.isValidIconThemeName "";
      expected = true;
    };

    testIsValidIconThemeName_NotAString = {
      expr = icons.isValidIconThemeName 42;
      expected = false;
    };

    # resolveIcons
    testResolveIcons_Empty = {
      expr = icons.resolveIcons {};
      expected = {
        name = null;
        theme = null;
      };
    };

    testResolveIcons_Valid = {
      expr = icons.resolveIcons {
        name = "Papirus";
        theme = "papirus";
      };
      expected = {
        name = "Papirus";
        theme = "papirus";
      };
    };

    testResolveIcons_NameOnly = {
      expr = icons.resolveIcons {
        name = "Papirus";
      };
      expected = {
        name = "Papirus";
        theme = null;
      };
    };

    testResolveIcons_ThemeOnly = {
      expr = icons.resolveIcons {
        theme = "papirus";
      };
      expected = {
        name = null;
        theme = "papirus";
      };
    };

    testResolveIcons_InvalidName = {
      expr = icons.resolveIcons {
        name = 6035;
      };
      expected = {
        name = null;
        theme = null;
      };
    };

    testResolveIcons_InvalidTheme = {
      expr = icons.resolveIcons {
        theme = "does-not-exist";
      };
      expected = {
        name = null;
        theme = null;
      };
    };

    testResolveIcons_InvalidNameWithValidTheme = {
      expr = icons.resolveIcons {
        name = 6035;
        theme = "papirus";
      };
      expected = {
        name = null;
        theme = "papirus";
      };
    };

    testResolveIcons_ValidNameWithInvalidTheme = {
      expr = icons.resolveIcons {
        name = "Papirus";
        theme = "does-not-exist";
      };
      expected = {
        name = "Papirus";
        theme = null;
      };
    };

    testResolveIcons_InvalidNameAndTheme = {
      expr = icons.resolveIcons {
        name = 6035;
        theme = "does-not-exist";
      };
      expected = {
        name = null;
        theme = null;
      };
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
