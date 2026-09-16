let
  presetAccents = {
    blue = true;
    green = true;
    orange = true;
    pink = true;
    purple = true;
    red = true;
    slate = true;
    teal = true;
    yellow = true;
  };
in rec {
  /**
  Supported GNOME accent preset colors.

  # Type

  ```
  presetAccents: AttrSet
  ```

  # Examples
  :::{.example}
  ## `config.presetAccents` usage example

  ```nix
  presetAccents
  => {
    blue = true;
    green = true;
    orange = true;
    pink = true;
    purple = true;
    red = true;
    slate = true;
    teal = true;
    yellow = true;
  }
  ```
  :::
  */
  inherit presetAccents;

  /**
  Checks whether the given value is a valid six digit hexadecimal color.

  # Inputs

  `accent`

  : The value to validate as a hexadecimal color.

  # Type

  ```
  isHexColor :: String -> Bool
  ```

  # Examples
  :::{.example}
  ## `config.isHexColor` usage example

  ```nix
  isHexColor "#191724"
  => true
  isHexColor "#GGGGGG"
  => false
  ```
  :::
  */
  isHexColor = accent: builtins.match "^#[0-9a-fA-F]{6}$" accent != null;

  /**
  Checks whether the given value is a supported GNOME accent preset.

  # Inputs

  `accent`

  : The accent value to check.

  # Type

  ```
  isPresetAccent :: String -> Bool
  ```

  # Examples
  :::{.example}
  ## `config.isPresetAccent` usage example

  ```nix
  isPresetAccent "purple"
  => true
  isPresetAccent "banana"
  => false
  ```
  :::
  */
  isPresetAccent = accent: builtins.hasAttr accent presetAccents;

  /**
  Resolves an accent into either a preset or a raw hexadecimal color.

  Throws an error if `accent` is neither a supported GNOME preset
  nor a valid six-digit hexadecimal color.

  # Inputs

  `accent`

  : The accent value to resolve.

  # Type

  ```
  resolveAccent :: String -> AttrSet
  ```

  # Examples
  :::{.example}
  ## `config.resolveAccent` usage example

  ```nix
  resolveAccent "purple"
  => {
    type = "preset";
    value = "purple";
  }
  resolveAccent "#191724"
  => {
    type = "color";
    value = "#191724";
  }
  resolveAccent "banana"
  => error: invalid accentColor: banana
  ```
  :::
  */
  resolveAccent = accent:
    if isPresetAccent accent
    then {
      type = "preset";
      value = accent;
    }
    else if isHexColor accent
    then {
      type = "color";
      value = accent;
    }
    else throw "invalid accentColor: ${accent}";
}
