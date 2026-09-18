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
  Checks whether the given value is a valid string.

  A value is considered to be a valid theme name, if it is `null` or a string.

  # Inputs

  `theme`

  : The name of the cursor theme.

  # Type

  ```
  isValidCursorThemeName :: Null | String -> Bool
  ```

  # Examples
  :::{.example}
  ## `isValidCursorThemeName` usage example

  ```nix
  isValidCursorThemeName "exists"
  => true
  isValidCursorThemeName null
  => true
  isValidCursorThemeName 6035
  => false
  ```
  :::
  */
  isValidCursorThemeName = name: isNull name || builtins.isString name;

  /**
  Resolves the cursor configuration from the given options.

  Invalid or unset cursor sizes fall back to `defaultCursorSize`.
  Invalid or unset cursor names fall back to `null`.
  Invalid or unset cursor themes fall back to `null`.
  Unset values are preserved as `null`.

  The cursor theme package is validated against the provided `pkgs` package set.
  The package is not verified to actually provide an cursor theme.

  # Inputs

  `size`

  : Optional cursor size to use. If unset or invalid, `defaultCursorSize` is used.

  `name`

  : Optional cursor theme package name to use. If unset or invalid, `null` is used.

  `theme`

  : Optional cursor theme package to use. If unset or invalid, `null` is used.

  # Type

  ```
  resolveCursor :: {
    size :: Null | Integer;
    name :: Null | String;
    theme :: Null | String;
  } -> {
    size :: Integer;
    name :: Null | String;
    theme :: Null | String;
  }
  ```

  # Examples
  :::{.example}
  ## `resolveCursor` usage example

  ```nix
  resolveCursor {
    size = 32;
    name = "exists";
    theme = "exists";
  }
  => {
    size = 32;
    name = "exists";
    theme = "exists";
  }
  resolveCursor {
    size = -1;
    name = 6035;
    theme = "does-not-exist";
  }
  => {
    size = 24;
    name = null;
    theme = null;
  }
  resolveCursor {
    theme = "does-not-exist";
  }
  => {
    size = 24;
    name = null;
    theme = null;
  }
  resolveCursor {}
  => {
    size = 24;
    name = null;
    theme = null;
  }
  ```
  :::
  */
  resolveCursor = {
    size ? null,
    name ? null,
    theme ? null,
  }: let
    resolvedSize =
      if size == null
      then defaultCursorSize
      else let
        isValid = isValidCursorSize size;
      in
        if isValid
        then size
        else defaultCursorSize;

    resolvedName =
      if isValidCursorThemeName name
      then name
      else null;

    resolvedTheme =
      if theme == null
      then null
      else let
        isValid = isValidCursorTheme theme;
      in
        if isValid
        then theme
        else null;
  in {
    size = resolvedSize;
    name = resolvedName;
    theme = resolvedTheme;
  };
}
