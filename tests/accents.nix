let
  accents = import ../config/accents.nix;
  presets = builtins.attrNames accents.presetAccents;
in
  {
    testPresetAccents = {
      expr = builtins.attrNames accents.presetAccents;
      expected = [
        "blue"
        "green"
        "orange"
        "pink"
        "purple"
        "red"
        "slate"
        "teal"
        "yellow"
      ];
    };

    # isHexColor
    testIsHexColor_Valid = {
      expr = accents.isHexColor "#191724";
      expected = true;
    };

    testIsHexColor_Uppercase = {
      expr = accents.isHexColor "#FFFFFF";
      expected = true;
    };

    testIsHexColor_MixedCase = {
      expr = accents.isHexColor "#aBc123";
      expected = true;
    };

    testIsHexColor_MissingHash = {
      expr = accents.isHexColor "191724";
      expected = false;
    };

    testIsHexColor_Short = {
      expr = accents.isHexColor "#FFF";
      expected = false;
    };

    testIsHexColor_Long = {
      expr = accents.isHexColor "#FFFFFFFF";
      expected = false;
    };

    testIsHexColor_InvalidCharacters = {
      expr = accents.isHexColor "#GGGGGG";
      expected = false;
    };

    testIsHexColor_Preset = {
      expr = accents.isHexColor "purple";
      expected = false;
    };

    # isPresetAccent
    testIsPresetAccent_Invalid = {
      expr = accents.isPresetAccent "banana";
      expected = false;
    };

    testIsPresetAccent_Hex = {
      expr = accents.isPresetAccent "#191724";
      expected = false;
    };

    # resolveAccent
    testResolveAccent_Hex = {
      expr = accents.resolveAccent "#191724";
      expected = {
        type = "color";
        value = "#191724";
      };
    };

    testResolveAccent_InvalidAccent = {
      expr = builtins.tryEval (accents.resolveAccent "banana");
      expected = {
        success = false;
        value = false;
      };
    };
  }
  # isPresetAccent_Presets
  // builtins.listToAttrs (
    map (
      c: {
        name = "testIsPresetAccent_${c}";
        value = {
          expr = accents.isPresetAccent c;
          expected = true;
        };
      }
    )
    presets
  )
  # resolveAccent_Presets
  // builtins.listToAttrs (
    map (
      c: {
        name = "testResolveAccent_${c}";
        value = {
          expr = accents.resolveAccent c;
          expected = {
            type = "preset";
            value = c;
          };
        };
      }
    )
    presets
  )
