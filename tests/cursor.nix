let
  fixturePkgs = {
    "adwaita-icon-theme" = {};
    "bibata-cursors" = {};
    "papirus-icon-theme" = {};
  };

  themes = builtins.attrNames fixturePkgs;
  cursor = import ../config/cursor.nix {pkgs = fixturePkgs;};
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

    # resolveCursor
    testResolveCursor_Empty = {
      expr = cursor.resolveCursor {};
      expected = {
        size = 24;
        theme = null;
      };
    };

    testResolveCursor_Valid = {
      expr = cursor.resolveCursor {
        cursorSize = 32;
        cursorTheme = "bibata-cursors";
      };
      expected = {
        size = 32;
        theme = "bibata-cursors";
      };
    };

    testResolveCursor_InvalidSizeFallsBack = {
      expr = cursor.resolveCursor {
        cursorSize = 0;
        cursorTheme = "bibata-cursors";
      };
      expected = {
        size = 24;
        theme = "bibata-cursors";
      };
    };

    testResolveCursor_InvalidThemeFallsBack = {
      expr = cursor.resolveCursor {
        cursorSize = 32;
        cursorTheme = "does-not-exist";
      };
      expected = {
        size = 32;
        theme = null;
      };
    };

    testResolveCursor_SizeOnly = {
      expr = cursor.resolveCursor {cursorSize = 48;};
      expected = {
        size = 48;
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
          expr = cursor.isValidCursorTheme p;
          expected = true;
        };
      }
    )
    themes
  )
