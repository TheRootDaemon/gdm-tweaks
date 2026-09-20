let
  fixturePkgs = {
    "adwaita-cursor-theme" = {type = "derivation";};
    "bibata-cursors" = {type = "derivation";};
    "papirus-cursor-theme" = {type = "derivation";};
  };

  themes = builtins.attrNames fixturePkgs;
  cursor = import ../config/cursor.nix;
in
  {
    # defaultCursorSize
    testDefaultCursorSize = {
      expr = cursor.defaultCursorSize;
      expected = 24;
    };

    # isValidCursorSize
    testIsValidCursorSize_Valid = {
      expr = cursor.isValidCursorSize 24;
      expected = true;
    };

    testIsValidCursorSize_Minimum = {
      expr = cursor.isValidCursorSize 1;
      expected = true;
    };

    testIsValidCursorSize_Zero = {
      expr = cursor.isValidCursorSize 0;
      expected = false;
    };

    testIsValidCursorSize_Negative = {
      expr = cursor.isValidCursorSize (-1);
      expected = false;
    };

    testIsValidCursorSize_Float = {
      expr = cursor.isValidCursorSize 24.5;
      expected = false;
    };

    testIsValidCursorSize_String = {
      expr = cursor.isValidCursorSize "24";
      expected = false;
    };

    # isValidCursorTheme
    testIsValidCursorTheme_Valid = {
      expr = cursor.isValidCursorTheme {type = "derivation";};
      expected = true;
    };

    testIsValidCursorTheme_EmptyAttr = {
      expr = cursor.isValidCursorTheme {};
      expected = false;
    };

    testIsValidCursorTheme_DoesNotExist = {
      expr = cursor.isValidCursorTheme "does-not-exist";
      expected = false;
    };

    testIsValidCursorTheme_EmptyString = {
      expr = cursor.isValidCursorTheme "";
      expected = false;
    };

    testIsValidCursorTheme_NotAString = {
      expr = cursor.isValidCursorTheme 42;
      expected = false;
    };

    testIsValidCursorTheme_Null = {
      expr = cursor.isValidCursorTheme null;
      expected = false;
    };

    # isValidThemeName
    testIsValidCursorThemeName_Valid = {
      expr = cursor.isValidCursorThemeName "exists";
      expected = true;
    };

    testIsValidCursorThemeName_Null = {
      expr = cursor.isValidCursorThemeName null;
      expected = true;
    };

    testIsValidCursorThemeName_EmptyString = {
      expr = cursor.isValidCursorThemeName "";
      expected = true;
    };

    testIsValidCursorThemeName_NotAString = {
      expr = cursor.isValidCursorThemeName 42;
      expected = false;
    };

    # resolveCursor
    testResolveCursor_Empty = {
      expr = cursor.resolveCursor {};
      expected = {
        size = 24;
        name = null;
        theme = null;
      };
    };

    testResolveCursor_Valid = {
      expr = cursor.resolveCursor {
        size = 32;
        name = "Bibata-Modern-Classic";
        theme = fixturePkgs."bibata-cursors";
      };
      expected = {
        size = 32;
        name = "Bibata-Modern-Classic";
        theme = fixturePkgs."bibata-cursors";
      };
    };

    testResolveCursor_NullSize = {
      expr = cursor.resolveCursor {
        size = null;
        name = "Bibata-Modern-Classic";
        theme = fixturePkgs."bibata-cursors";
      };
      expected = {
        size = 24;
        name = "Bibata-Modern-Classic";
        theme = fixturePkgs."bibata-cursors";
      };
    };

    testResolveCursor_InvalidSizeFallsBack = {
      expr = cursor.resolveCursor {
        size = 0;
        name = "Bibata-Modern-Classic";
        theme = fixturePkgs."bibata-cursors";
      };
      expected = {
        size = 24;
        name = "Bibata-Modern-Classic";
        theme = fixturePkgs."bibata-cursors";
      };
    };

    testResolveCursor_InvalidThemeFallsBack = {
      expr = cursor.resolveCursor {
        size = 32;
        theme = "does-not-exist";
      };
      expected = {
        size = 32;
        name = null;
        theme = null;
      };
    };

    testResolveCursor_InvalidThemeNameFallsBack = {
      expr = cursor.resolveCursor {
        size = 32;
        name = 6035;
        theme = fixturePkgs."bibata-cursors";
      };
      expected = {
        size = 32;
        name = null;
        theme = fixturePkgs."bibata-cursors";
      };
    };

    testResolveCursor_SizeOnly = {
      expr = cursor.resolveCursor {size = 48;};
      expected = {
        size = 48;
        name = null;
        theme = null;
      };
    };

    testResolveCursor_NameOnly = {
      expr = cursor.resolveCursor {
        name = "Bibata-Modern-Classic";
      };
      expected = {
        size = 24;
        name = "Bibata-Modern-Classic";
        theme = null;
      };
    };

    testResolveCursor_InvalidSizeAndNameAndTheme = {
      expr = cursor.resolveCursor {
        size = -1;
        name = 6035;
        theme = "does-not-exist";
      };
      expected = {
        size = 24;
        name = null;
        theme = null;
      };
    };
  }
  # isValidCursorTheme_Exists
  // builtins.listToAttrs (
    map (
      p: {
        name = "testIsValidCursorTheme_${p}";
        value = {
          expr = cursor.isValidCursorTheme fixturePkgs.${p};
          expected = true;
        };
      }
    )
    themes
  )
