{pkgs}: let
  packageUtils = import ./pkgs.nix {inherit pkgs;};
in rec {
  /**
  Default cursor size.

  # Type

  ```
  defaultCursorSize: Integer
  ```

  # Examples
  :::{.example}
  ## `defaultCursorSize` usage example

  ```nix
  defaultCursorSize
  => 24
  ```
  :::
  */
  defaultCursorSize = 24;

  /**
  Checks whether the given value is a valid cursor size.

  A valid size must be an integer greater than zero.

  # Inputs

  `size`

  : The cursor size to validate.

  # Type

  ```
  isValidCursorSize :: Integer -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidCursorSize` usage example

  ```nix
  isValidCursorSize 24
  => true
  isValidCursorSize 0
  => false
  isValidCursorSize -1
  => false
  ```
  :::
  */
  isValidCursorSize = size: builtins.isInt size && size > 0;

  /**
  Checks whether the given value is the name of an attribute
  available in the provided `pkgs` package set.

  This only checks whether the package exists.
  It does not verify that the package is actually a cursor theme.

  # Inputs

  `theme`

  : The name of the cursor theme package.

  # Type

  ```
  isValidCursorTheme :: String -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidCursorTheme` usage example

  ```nix
  isValidCursorTheme "exists"
  => true
  isValidCursorTheme "does-not-exist"
  => false
  ```
  :::
  */
  isValidCursorTheme = theme: packageUtils.isValidPackage theme;

  /**
  Resolves the cursor configuration from the given options.

  Invalid or unset cursor sizes fall back to `defaultCursorSize`.
  Invalid or unset cursor themes fall back to `null`.

  # Inputs

  `cursorSize`

  : Optional cursor size to use. If unset or invalid, `defaultCursorSize` is used.

  `cursorTheme`

  : Optional cursor theme to use. If unset or invalid, `null` is used.

  # Type

  ```
  resolveCursor :: {
    cursorSize :: Null | Integer;
    cursorTheme :: Null | String;
  } -> {
    size :: Integer;
    theme :: Null | String;
  }
  ```

  # Examples
  :::{.example}
  ## `resolveCursor` usage example

  ```nix
  resolveCursor {
    cursorSize = 32;
    cursorTheme = "exists";
  }
  => {
    size = 32;
    theme = "exists";
  }
  resolveCursor {
    cursorSize = -1;
    cursorTheme = "does-not-exist";
  }
  => {
    size = 24;
    theme = null;
  }
  resolveCursor {
    cursorTheme = "does-not-exist";
  }
  => {
    size = 24;
    theme = null;
  }
  resolveCursor {}
  => {
    size = 24;
    theme = null;
  }
  ```
  :::
  */
  resolveCursor = {
    cursorSize ? null,
    cursorTheme ? null,
  }: let
    resolvedSize =
      if cursorSize == null
      then defaultCursorSize
      else let
        isValid = isValidCursorSize cursorSize;
      in
        if isValid
        then cursorSize
        else defaultCursorSize;

    resolvedTheme =
      if cursorTheme == null
      then null
      else let
        isValid = isValidCursorTheme cursorTheme;
      in
        if isValid
        then cursorTheme
        else null;
  in {
    size = resolvedSize;
    theme = resolvedTheme;
  };
}
